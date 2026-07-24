#!/usr/bin/env bash
# 聚合统计所有 claude-* 会话,按状态输出主题色图标计数(分段样式由 tmux-power.tmux 负责)
# 状态取自 ~/.claude/sessions/<pane_pid>.json;分类规则见 claude-lib.sh 的 claude_classify
# 颜色:待授权黄 / 待回答橙 / 一般等待黄 / 运行中蓝 / 空闲灰(CLR_* 见 claude-lib.sh)

source "${BASH_SOURCE[0]%/*}/claude-lib.sh"
prefix="$(tmux_get @claude_session_prefix "${CLAUDE_SESSION_PREFIX:-claude-}")"
sessions_dir="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/sessions}"

# 状态色由 claude-lib.sh 统一载入(CLR_*),与 picker 同源
claude_load_colors

# pm=待授权 q=待回答 w=一般等待 k=运行中 i=空闲
# 只统计当前 claude-* tmux 会话(claude_session_pids,与 list.sh 同源);
# claude_classify 纯 bash 解析并回传 REPLY,不 fork(见 claude-lib.sh)
pm=0 q=0 w=0 k=0 i=0
while IFS= read -r pid; do
  j=""; f="$sessions_dir/$pid.json"
  [ -r "$f" ] && j=$(<"$f")
  claude_classify "$j"
  case "$REPLY" in
    permission) ((pm++)) ;;
    question)   ((q++)) ;;
    waiting)    ((w++)) ;;
    working)    ((k++)) ;;
    *)          ((i++)) ;;
  esac
done < <(claude_session_pids)

# 存在待介入会话(待授权/待回答/一般等待)时置 @claude_attn,供状态栏 agents 分段底色变红
if (( pm + q + w > 0 )); then
  tmux set-option -g @claude_attn 1
else
  tmux set-option -g @claude_attn ''
fi

# 按紧迫度从高到低输出各非零分类
out=""
[ "$pm" -gt 0 ] && out+="#[fg=$CLR_YELLOW] $pm  "
[ "$q"  -gt 0 ] && out+="#[fg=$CLR_ORANGE]󰋗 $q  "
[ "$w"  -gt 0 ] && out+="#[fg=$CLR_YELLOW]󰔟 $w  "
[ "$k"  -gt 0 ] && out+="#[fg=$CLR_BLUE] $k  "
[ "$i"  -gt 0 ] && out+="#[fg=$CLR_GREY]󰟃 $i  "
out="${out%  }"

[ -z "$out" ] && { echo "-"; exit 0; }
printf '%s#[fg=default]\n' "$out"
