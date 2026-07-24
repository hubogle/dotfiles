#!/usr/bin/env bash
# claude 会话选择器:fzf 列出所有 claude-* 会话(左侧列表:状态胶囊/git 摘要),
# 右侧预览选中会话的当前画面。回车 attach。流程:列表 → 渲染 → 选择预览 → attach。
set -uo pipefail

prefix="${CLAUDE_SESSION_PREFIX:-claude-}"
# claude 会话注册表:每个活动会话一份 <pid>.json,含实时 name/status。
# launch.sh 用 exec 启动,tmux #{pane_pid} 即 json 文件名里的 pid
sessions_dir="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/sessions}"
source "${BASH_SOURCE[0]%/*}/claude-lib.sh"

# 性能:固定开销一次算进 build_theme,渲染只做字符串拼接 + printf -v(零 fork)。

# #RRGGBB -> "r;g;b"(printf -v 直接写 REPLY,不 fork)
rgb() {
  local h=${1#\#}
  printf -v REPLY '%d;%d;%d' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"
}

# 状态胶囊:状态色作底、背景色作字。mkpill <#状态色> <文字> -> REPLY=ANSI, REPLY2=可见宽度
# 需 _bgrgb 先由 build_theme 备好(背景色 rgb)
mkpill() {
  local srgb
  rgb "$1"; srgb=$REPLY
  REPLY=$'\033[38;2;'"${_bgrgb};48;2;${srgb}m$2"$'\033[0m'
  REPLY2=${#2}
}

# 一次性预算主题相关的所有 ANSI:R/B/D 常量、git 摘要固定色前缀、5 类状态胶囊。
# 之后渲染逐行/逐会话都只是查这些变量,零 fork。
build_theme() {
  claude_load_colors           # CLR_*(库内一次 show-options 批量取回)
  R=$'\033[0m'; B=$'\033[1m'; D=$'\033[2m'
  rgb "$CLR_BG";     _bgrgb=$REPLY
  rgb "$CLR_YELLOW"; FG_YEL=$'\033[38;2;'"$REPLY"m     # git 变动数
  rgb "$CLR_GREEN";  FG_GREEN=$'\033[38;2;'"$REPLY"m   # git 新增
  rgb "$CLR_RED";    FG_RED=$'\033[38;2;'"$REPLY"m     # git 删除
  rgb "$CLR_GREY";   FG_GREY=$'\033[38;2;'"$REPLY"m    # git 分支
  # 类别 → 胶囊(颜色:待授权/等待黄、待回答橙、运行中蓝、空闲灰)
  mkpill "$CLR_YELLOW" ' permission '; PILL_PERM=$REPLY; PILLW_PERM=$REPLY2
  mkpill "$CLR_ORANGE" ' question ';   PILL_QUES=$REPLY; PILLW_QUES=$REPLY2
  mkpill "$CLR_YELLOW" ' waiting ';    PILL_WAIT=$REPLY; PILLW_WAIT=$REPLY2
  mkpill "$CLR_BLUE"   ' working ';    PILL_WORK=$REPLY; PILLW_WORK=$REPLY2
  mkpill "$CLR_GREY"   ' idle ';       PILL_IDLE=$REPLY; PILLW_IDLE=$REPLY2
}

# git 变动摘要着色:git_summary <changes> <adds> <dels>
#   REPLY  = 彩色串 "!N +A -D"(干净则空)   REPLY2 = 去 ANSI 的可见宽度(供次行右对齐)
git_summary() {
  local changes=$1 adds=$2 dels=$3
  REPLY=""; REPLY2=0
  (( changes > 0 )) || return
  REPLY="${FG_YEL}!${changes}${R}"; REPLY2=$(( 1 + ${#changes} ))
  (( adds > 0 )) && { REPLY+=" ${FG_GREEN}+${adds}${R}"; REPLY2=$(( REPLY2 + 2 + ${#adds} )); }
  (( dels > 0 )) && { REPLY+=" ${FG_RED}-${dels}${R}"; REPLY2=$(( REPLY2 + 2 + ${#dels} )); }
}

# 采集单会话 git:BRANCH=分支名,并调 git_summary 让 REPLY/REPLY2 = 彩色摘要/宽度。
# 顺序采集(会话数少,无需后台并行/临时文件)。
collect_git() {
  local path="$1" git_out first branch changes nl a d adds=0 dels=0 has_head=1
  branch=""; changes=0
  # 一次 status --porcelain=v1 --branch:首行 "## …" 给分支,其余每行一个变动文件
  if git_out=$(git -C "$path" status --porcelain=v1 --branch 2>/dev/null); then
    first="${git_out%%$'\n'*}"; first="${first#\#\# }"
    case "$first" in
      'HEAD (no branch)')    branch="detached @ $(git -C "$path" rev-parse --short HEAD 2>/dev/null)" ;;
      'No commits yet on '*) branch="${first#No commits yet on }"; has_head=0 ;;  # 无初始提交,无 HEAD
      *)                     branch="${first%%...*}"; branch="${branch%% *}" ;;
    esac
    nl="${git_out//[!$'\n']/}"; changes=${#nl}
    # 无初始提交仓库没有 HEAD,跳过 diff HEAD(否则报错且无意义)
    if (( changes > 0 && has_head )); then
      # numstat 每行 "<+> <-> <path>";二进制文件为 "- -",非数字跳过
      while read -r a d _; do
        [[ $a == [0-9]* ]] && adds=$(( adds + a ))
        [[ $d == [0-9]* ]] && dels=$(( dels + d ))
      done < <(git -C "$path" diff HEAD --numstat 2>/dev/null)
    fi
  fi
  BRANCH=$branch
  git_summary "$changes" "$adds" "$dels"
}

# 目标列宽:内容下限(最长名+10、次行 git 摘要+时长列的所需宽度)
# 与 popup 列表窗格实际宽度(16% 列表-装饰列)取大者。
# target_width <name_w> <glen_max> <ago_w> -> REPLY
target_width() {
  local name_w=$1 glen_max=$2 ago_w=$3 w term_w
  w=$(( name_w + 10 ))
  (( 1 + glen_max + 1 + ago_w > w )) && w=$(( 1 + glen_max + 1 + ago_w ))
  # 只取一次 stty size("rows cols"),bash 内置切出列数,不 fork awk/cut
  local size=""; size=$(stty size </dev/tty 2>/dev/null); term_w=${size#* }
  case "$term_w" in ''|*[!0-9]*) term_w="" ;; esac
  [ -n "$term_w" ] && (( term_w * 16 / 100 - 6 > w )) && w=$(( term_w * 16 / 100 - 6 ))
  REPLY=$w
}

# 输出 NUL 分隔的多行卡片(供 fzf --read0)
# 字段:rank \t 状态时间戳 \t 会话名 \t 路径 \t 卡片(fzf 只显示卡片)
# 排序:最近进入者置顶(rank=-1),其余 permission > question > waiting > idle > working,
# 层内按状态时间戳倒序(最近的在前)
emit_rows() {
  local now s at path rank ago dir branch card idx pid sfile sjson pill pillw
  local W la pad padsp agosp gpadsp lpadsp right gpad avail
  local name_w=0 last_idx=-1 last_max=0 ago_w=0 glen_max=0
  local -a sess ats dirs paths pills pillws ranks agos branches ginfos glens

  build_theme            # 一次性预算主题色/ANSI/5 类胶囊,后续渲染零 fork
  now=$(date +%s)

  # 第一遍:一次 list-sessions 取全字段(\x1f 分隔,避免 tab 被 IFS 折叠丢空字段),
  # 逐会话解析要展示的字段(name / statusUpdatedAt / 分类)并顺序采集 git。
  idx=0
  while IFS=$'\x1f' read -r s la pid path; do
    dir="${s#$prefix}"                       # 默认取 session 名去前缀
    at=""; REPLY=idle                        # 无 json → 按空闲渲染
    sfile="$sessions_dir/$pid.json"
    if [ -r "$sfile" ]; then
      sjson=$(<"$sfile")                     # bash 直读,不 fork
      case "$sjson" in *'"name":"'*) dir="${sjson#*\"name\":\"}"; dir="${dir%%\"*}" ;; esac
      case "$sjson" in
        *'"statusUpdatedAt":'*)
          # 截到第一个非数字为止;必须用 [!0-9](含 } 的模式会在 ${} 里提前闭合)
          at="${sjson#*\"statusUpdatedAt\":}"; at="${at%%[!0-9]*}"
          case "$at" in ''|*[!0-9]*) at="" ;; *) at=$(( at / 1000 )) ;; esac ;;
      esac
      claude_classify "$sjson"               # -> REPLY = 类别
    fi
    dir="${dir%-*}"                          # 去掉末尾 -<后缀>(如 dotfiles-1d → dotfiles)
    (( ${#dir} > 25 )) && dir="${dir:0:24}…"

    # 类别 → 预算好的胶囊/宽度/排位(查表,零 fork)
    case "$REPLY" in
      permission) pill=$PILL_PERM; pillw=$PILLW_PERM; rank=0 ;;
      question)   pill=$PILL_QUES; pillw=$PILLW_QUES; rank=1 ;;
      waiting)    pill=$PILL_WAIT; pillw=$PILLW_WAIT; rank=2 ;;
      working)    pill=$PILL_WORK; pillw=$PILLW_WORK; rank=4 ;;
      *)          pill=$PILL_IDLE; pillw=$PILLW_IDLE; rank=3 ;;
    esac

    fmt_ago "$at" "$now"; ago=$REPLY
    collect_git "$path"                      # -> BRANCH,REPLY=彩色摘要,REPLY2=宽度

    sess+=("$s"); ats+=("$at"); dirs+=("$dir"); paths+=("$path")
    pills+=("$pill"); pillws+=("$pillw"); ranks+=("$rank"); agos+=("$ago")
    branches+=("$BRANCH"); ginfos+=("$REPLY"); glens+=("$REPLY2")
    (( REPLY2 > glen_max )) && glen_max=$REPLY2
    (( ${#ago} > ago_w )) && ago_w=${#ago}
    (( ${#dir} > name_w )) && name_w=${#dir}
    # 记录最近一次 attach 过的会话下标,渲染时置顶
    [ -n "$la" ] && (( la > last_max )) && { last_max=$la; last_idx=$idx; }
    idx=$(( idx + 1 ))
  done < <(tmux list-sessions -f "#{m:${prefix}*,#{session_name}}" \
             -F $'#{session_name}\x1f#{session_last_attached}\x1f#{pane_pid}\x1f#{pane_current_path}' 2>/dev/null)

  [ "${#sess[@]}" -eq 0 ] && return 0

  target_width "$name_w" "$glen_max" "$ago_w"; W=$REPLY

  # 第二遍:渲染卡片,右边缘统一对齐到 W。补空格一律 printf -v(不开子 shell)。
  for idx in "${!sess[@]}"; do
    s=${sess[idx]}; at=${ats[idx]}; dir=${dirs[idx]}; branch=${branches[idx]}
    pill=${pills[idx]}; pillw=${pillws[idx]}; rank=${ranks[idx]}; ago=${agos[idx]}
    (( idx == last_idx )) && rank=-1

    # 首行:目录名 + 状态徽章右对齐;换行先用 \x1f 占位,保证 sort 按整卡排序
    pad=$(( W - 1 - ${#dir} - pillw ))
    (( pad < 1 )) && pad=1
    printf -v padsp '%*s' "$pad" ''
    card=" ${B}${dir}${R}${padsp}${pill}"

    # 次行:git 摘要在左,定宽时长列右对齐成竖列
    printf -v agosp '%*s' "$ago_w" "$ago"
    right="${D}${agosp}${R}"
    if [ -n "${ginfos[idx]}" ]; then
      gpad=$(( W - 1 - glens[idx] - ago_w ))
      (( gpad < 1 )) && gpad=1
      printf -v gpadsp '%*s' "$gpad" ''
      card+=$'\x1f'" ${ginfos[idx]}${gpadsp}${right}"
    else
      printf -v lpadsp '%*s' "$(( W - ago_w ))" ''
      card+=$'\x1f'"${lpadsp}${right}"
    fi

    # 末行:分支,超长截断;无仓库则跳过
    if [ -n "$branch" ]; then
      avail=$(( W - 1 ))
      (( ${#branch} > avail )) && branch="${branch:0:avail-1}…"
      card+=$'\x1f'" ${FG_GREY}${branch}${R}"
    fi
    printf '%s\t%s\t%s\t%s\t%s\n' "$rank" "${at:-0}" "$s" "${paths[idx]}" "$card"
  done |
  sort -t $'\t' -k1,1n -k2,2rn |
  while IFS= read -r rec; do printf '%s\0' "${rec//$'\x1f'/$'\n'}"; done
}

run_picker() {
  if ! command -v fzf >/dev/null 2>&1; then
    tmux display-message "tmux-claude-session-manager: fzf is required for the picker"
    exit 0
  fi

  local sel first target
  # 预览直接抓选中会话当前可见画面(-e 带颜色,-p 输出到 stdout,-S -500 带回滚)。
  # (否则目标名带上字面引号而匹配不到任何会话,预览空白);follow 让预览贴底显示最新画面。
  # \= 转义前导等号:fzf 用 $SHELL(可能是 zsh)跑预览,zsh 对未引用的前导 = 触发
  # EQUALS 展开(把 =name 当成命令 name 求路径),导致 "name not found";转义后 tmux 收到字面 =name。
  # 2>/dev/null 让选择期间会话退出时预览安静留空
  sel=$(emit_rows | fzf --ansi --read0 \
    --reverse --cycle \
    --delimiter=$'\t' \
    --with-nth=5.. \
    --gap=1 \
    --highlight-line \
    --style=full \
    --preview='tmux capture-pane -ept {3} -S -500 2>/dev/null' \
    --preview-window='right,84%,nowrap,follow') || return 0     # fzf 被取消(Esc/非零退出)则直接返回

  [ -z "$sel" ] && exit 0
  # 卡片是多行记录:取首行、按 tab 切出第 3 字段会话名(bash 内置,不 fork head/cut)
  first="${sel%%$'\n'*}"
  IFS=$'\t' read -r _ _ target _ <<<"$first"
  target=${target:-}
  # attach 前用 =name 精确匹配确认会话仍在;已退出则提示并正常结束
  if [ -z "$target" ] || ! tmux has-session -t "=$target" 2>/dev/null; then
    tmux display-message "claude session '${target:-?}' no longer exists"
    exit 0
  fi
  tmux attach-session -t "=$target"
}

# 当前 attach 在某个 claude-* 会话上的客户端 → 返回其会话名(即已展开的弹窗)。
# picker 与 launch 都把 claude 会话 attach 进 popup,该 popup 客户端的 session_name 即 claude-*。
nested_session() {
  tmux list-clients -F '#{client_name} #{session_name}' 2>/dev/null |
    awk -v p="$prefix" 'index($2, p) == 1 { print $2; exit }'
}

# 宿主客户端:未停留在 claude-* 会话上的外层真实终端客户端 → 返回其 client_name。
host_client() {
  tmux list-clients -F '#{client_name} #{session_name}' 2>/dev/null |
    awk -v p="$prefix" 'index($2, p) != 1 { print $1; exit }'
}

# 弹窗跑 picker(默认入口)。tmux 每个客户端同一时刻只能有一个 popup:
# 若此刻正停在某 claude 弹窗里(P 未先按 Esc 收起),直接开 picker 会因 popup 嵌套而打不开。
# 故先 detach 收起该 claude 弹窗(会话后台保留,同 Esc 行为),再显式在宿主客户端上开 picker。
open_popup() {
  local w h sess host
  w="$(tmux_get @claude_popup_width '99%')"
  h="$(tmux_get @claude_popup_height '95%')"

  sess="$(nested_session)"
  if [ -n "$sess" ]; then
    tmux detach-client -s "$sess"
    # 等待 detach 生效(popup 关闭)后再开,最多 ~5s;否则 popup 仍占用导致 picker 打不开
    for _ in $(seq 1 100); do
      [ -z "$(nested_session)" ] && break
      sleep 0.05
    done
  fi

  host="$(host_client)"
  if [ -n "$host" ]; then
    tmux display-popup -c "$host" -w "$w" -h "$h" -E "$0 --picker"
  else
    tmux display-popup -w "$w" -h "$h" -E "$0 --picker"
  fi
}

case "${1:-}" in
  --list) emit_rows ;;
  --picker) run_picker ;;
  *) open_popup ;;
esac
