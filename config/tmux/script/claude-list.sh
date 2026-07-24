#!/usr/bin/env bash
# claude 会话选择器:fzf 列出所有 claude-* 会话(左侧列表:状态胶囊/git 摘要),
# 右侧预览选中会话的当前画面。回车 attach。流程:列表 → 渲染 → 选择预览 → attach。
set -uo pipefail

source "${BASH_SOURCE[0]%/*}/claude-lib.sh"
prefix="$(tmux_get @claude_session_prefix "${CLAUDE_SESSION_PREFIX:-claude-}")"
sessions_dir="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/sessions}"

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

# 解析 `claude -p /usage` 输出，生成 fzf 顶部的紧凑额度摘要。
# claude_usage_parse <output> -> REPLY="1:09am(23%) • Week(62%) • Fable(100%)"
claude_usage_parse() {
  local output=$1 line session_pct session_reset week_pct fable_pct
  session_pct=""; session_reset=""; week_pct=""; fable_pct=""

  while IFS= read -r line; do
    case "$line" in
      'Current session:'*)
        if [[ $line =~ ([0-9]+)%[[:space:]]used.*at[[:space:]]([0-9]{1,2}:[0-9]{2}[[:alpha:]]{2}) ]]; then
          session_pct=${BASH_REMATCH[1]}
          session_reset=${BASH_REMATCH[2]}
        fi
        ;;
      'Current week (all models):'*)
        [[ $line =~ ([0-9]+)%[[:space:]]used ]] && week_pct=${BASH_REMATCH[1]}
        ;;
      'Current week (Fable):'*)
        [[ $line =~ ([0-9]+)%[[:space:]]used ]] && fable_pct=${BASH_REMATCH[1]}
        ;;
    esac
  done <<<"$output"

  if [ -n "$session_pct" ] && [ -n "$session_reset" ] && [ -n "$week_pct" ] && [ -n "$fable_pct" ]; then
    REPLY="${session_reset}(${session_pct}%) • Week(${week_pct}%) • Fable(${fable_pct}%)"
  else
    REPLY=""
  fi
}

# 后台查询并缓存额度。缓存和时间戳属于 tmux server，而非某一个 shell 进程。
claude_usage_refresh() {
  local raw now
  # tmux server 未必带有 mise 的 shim 路径；找不到 claude 时，以交互 zsh
  # 加载用户配置后查询。只保留 /usage 返回的三行 Current 信息供后续解析。
  if command -v claude >/dev/null 2>&1; then
    raw=$(claude -p '/usage' 2>/dev/null | grep 'Current')
  else
    raw=$(zsh -ic 'claude -p "/usage"' 2>/dev/null | grep 'Current')
  fi
  claude_usage_parse "$raw"
  now=$(date +%s)
  if [ -n "$REPLY" ]; then
    tmux set-option -g @claude_usage_cache "$REPLY"
  else
    tmux set-option -g @claude_usage_cache '额度查询失败'
  fi
  tmux set-option -g @claude_usage_cache_at "$now"
  tmux set-option -g @claude_usage_querying ''
  tmux set-option -g @claude_usage_querying_at ''
}

# 读取 10 分钟额度缓存；过期时异步启动查询，避免阻塞 fzf 打开。
# claude_usage_display -> REPLY=缓存摘要或“额度查询中...”
claude_usage_display() {
  local cache checked querying querying_at ttl now refresh_cmd
  cache="$(tmux_get @claude_usage_cache '')"
  checked="$(tmux_get @claude_usage_cache_at '')"
  querying="$(tmux_get @claude_usage_querying '')"
  querying_at="$(tmux_get @claude_usage_querying_at '')"
  ttl="$(tmux_get @claude_usage_cache_ttl '600')"
  now=$(date +%s)
  case "$ttl" in ''|*[!0-9]*) ttl=600 ;; esac

  if [[ $checked =~ ^[0-9]+$ ]] && [ -n "$cache" ] && [ "$cache" != '额度查询失败' ] && (( now - checked < ttl )); then
    REPLY=$cache
    return
  fi

  # 后台子进程若被 popup 关闭时一并终止，30 秒后允许下次打开自动恢复查询。
  if [ "$querying" = 1 ] && { [[ ! $querying_at =~ ^[0-9]+$ ]] || (( now - querying_at >= 30 )); }; then
    tmux set-option -g @claude_usage_querying ''
    querying=""
  fi
  if [ "$querying" != 1 ]; then
    tmux set-option -g @claude_usage_querying 1
    tmux set-option -g @claude_usage_querying_at "$now"
    # 让 tmux server 独立运行查询，避免后台 Claude CLI 继承 fzf popup 的终端，
    # 与 fzf 的输入和渲染发生竞争。
    printf -v refresh_cmd '%q --refresh-usage' "${BASH_SOURCE[0]}"
    tmux run-shell -b "$refresh_cmd"
  fi
  REPLY='额度查询中...'
}

# 输出 NUL 分隔的多行卡片(供 fzf --read0)
# 字段:rank \t 状态时间戳 \t 会话名 \t 路径 \t 卡片(fzf 只显示卡片)
# 排序:最近进入者置顶(rank=-1),其余 permission > question > waiting > idle > working,
# 层内按状态时间戳倒序(最近的在前)
emit_rows() {
  local now s at path rank ago dir branch card idx pid sfile sjson pill pillw cache_idx git_cached
  local W la pad padsp agosp gpadsp lpadsp right gpad avail
  local name_w=0 last_idx=-1 last_max=0 ago_w=0 glen_max=0
  local -a sess ats dirs paths pills pillws ranks agos branches ginfos glens
  local -a git_paths git_branches git_infos git_lens

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
    git_cached=0
    for cache_idx in "${!git_paths[@]}"; do
      if [[ ${git_paths[cache_idx]} == "$path" ]]; then
        BRANCH=${git_branches[cache_idx]}
        REPLY=${git_infos[cache_idx]}
        REPLY2=${git_lens[cache_idx]}
        git_cached=1
        break
      fi
    done
    if (( ! git_cached )); then
      collect_git "$path"                    # -> BRANCH,REPLY=彩色摘要,REPLY2=宽度
      git_paths+=("$path")
      git_branches+=("$BRANCH")
      git_infos+=("$REPLY")
      git_lens+=("$REPLY2")
    fi

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

  local host=${1:-} sel first target self reload_cmd kill_toggle_cmd clear_kill_cmd usage_cmd usage
  self=${BASH_SOURCE[0]}
  printf -v reload_cmd '%q --list' "$self"
  printf -v kill_toggle_cmd '%q --toggle-kill' "$self"
  printf -v clear_kill_cmd '%q --clear-kill-confirm' "$self"
  printf -v usage_cmd '%q --usage' "$self"
  clear_kill_confirmation
  claude_usage_display; usage=$REPLY
  # 预览只轮询当前选中会话的可见画面(-e 带颜色,-p 输出到 stdout)。
  # fzf 变更选择时会终止旧预览并启动新预览，因此不会轮询列表里的其他会话。
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
    --info=hidden \
    --no-scrollbar \
    --header="$usage" \
    --bind="ctrl-r:reload($reload_cmd)+transform-header($usage_cmd)+refresh-preview" \
    --bind="ctrl-x:transform($kill_toggle_cmd {3})" \
    --bind="focus:execute-silent($clear_kill_cmd)+transform-header($usage_cmd)" \
    --preview='while :; do printf "\033[3J\033[2J\033[H"; tmux capture-pane -ept {3} 2>/dev/null; sleep 1; done' \
    --preview-window='right,84%,nowrap,nofollow,noinfo') || return 0   # fzf 被取消(Esc/非零退出)则直接返回

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
  [ -n "$host" ] && tmux set-option -t "=$target" @claude_host_client "$host"
  tmux attach-session -t "=$target"
}

# 关闭指定 Claude session；= 前缀要求 tmux 精确匹配会话名，避免前缀歧义。
kill_session() {
  local target=${1:-}
  [ -n "$target" ] || return 0
  tmux kill-session -t "=$target" 2>/dev/null
}

clear_kill_confirmation() {
  tmux set-option -g @claude_kill_confirm_session ''
}

# fzf 的 transform 动作会把 stdout 当作新的 fzf 动作执行。第一次 Ctrl-X 仅写入
# 确认状态并更新 header；同一会话第二次 Ctrl-X 才真正关闭。
kill_toggle_action() {
  local target=${1:-} armed self reload_cmd usage_cmd
  [ -n "$target" ] || return 0
  armed="$(tmux_get @claude_kill_confirm_session '')"

  if [ "$armed" = "$target" ]; then
    kill_session "$target"
    clear_kill_confirmation
    self=${BASH_SOURCE[0]}
    printf -v reload_cmd '%q --list' "$self"
    printf -v usage_cmd '%q --usage' "$self"
    printf 'reload(%s)+transform-header(%s)\n' "$reload_cmd" "$usage_cmd"
    return
  fi

  tmux set-option -g @claude_kill_confirm_session "$target"
  printf '%s\n' 'change-header(⚠ 再按一次 Ctrl-X 关闭；Esc 取消)'
}

client_session() {
  [ -n "$1" ] && tmux display-message -p -c "$1" '#{session_name}' 2>/dev/null
}

picker_command() {
  printf -v REPLY '%q --picker %q' "$0" "$1"
}

# 弹窗跑 picker(默认入口)。调用方客户端由 tmux key binding 显式传入。
open_popup() {
  local caller_client=${1:-} current_session host picker_cmd y
  local w h
  w="$(tmux_get @claude_popup_width '100%')"
  h="$(tmux_get @claude_popup_height '100%')"

  current_session="$(client_session "$caller_client")"
  host=$caller_client
  if [[ "$current_session" == "$prefix"* ]]; then
    host="$(tmux show-options -qv -t "=$current_session" @claude_host_client 2>/dev/null)"
    host=${host:-$caller_client}
    tmux detach-client -t "$caller_client" 2>/dev/null
  fi

  claude_popup_dims "$host" "$w" "$h"; w=$REPLY; h=$REPLY2   # 100% 高度预留顶部状态栏(host 空时回退百分比)
  picker_command "$host"; picker_cmd=$REPLY
  if [ -n "$host" ]; then
    # 无框避免透明终端中边框独立重绘时闪出底层 pane 内容。
    tmux display-popup -b none -c "$host" -w "$w" -h "$h" -y S -E "$picker_cmd"
  else
    tmux display-popup -b none -w "$w" -h "$h" -y S -E "$picker_cmd"
  fi
}

case "${1:-}" in
  --list) emit_rows ;;
  --toggle-kill) kill_toggle_action "${2:-}" ;;
  --clear-kill-confirm) clear_kill_confirmation ;;
  --refresh-usage) claude_usage_refresh ;;
  --usage)
    claude_usage_display
    printf '%s\n' "$REPLY"
    ;;
  --picker) run_picker "${2:-}" ;;
  *) open_popup "${1:-}" ;;
esac
