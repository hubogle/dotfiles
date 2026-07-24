#!/usr/bin/env bash
# 在弹窗中新开一个 claude 会话:launch.sh <path> <origin_session>
set -uo pipefail

source "${BASH_SOURCE[0]%/*}/claude-lib.sh"

path="${1:-$PWD}"
origin_session="${2:-}"

prefix="$(tmux_get @claude_session_prefix 'claude-')"
cmd="$(tmux_get @claude_command 'claude')"
w="$(tmux_get @claude_popup_width '99%')"
h="$(tmux_get @claude_popup_height '95%')"
sessions_dir="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/sessions}"

# 已经在 claude 弹窗里,不允许再嵌套开一个
if [[ "$origin_session" == "$prefix"* ]]; then
    tmux display-message "Claude popup already open"
    exit 0
fi

dir_name="${path%/}"; dir_name="${dir_name##*/}"

# 新建会话运行 claude:exec 使 pane_pid 即 claude 进程 pid,
# 对应注册表文件 ~/.claude/sessions/<pid>.json。
# 先用 claude-<pid> 占位命名,后台等 json 写入 name 后再改名;
# 全程按 session_id 寻址,改名与 attach 互不干扰
out=$(tmux new-session -d -c "$path" -P -F '#{session_id} #{pane_pid}' "zsh -ic 'exec $cmd'")
read -r sid pp <<<"$out"

tmux rename-session -t "$sid" "${prefix}${pp}" 2>/dev/null

tmux set-hook   -t "$sid" pane-exited "kill-session"
tmux set-option -t "$sid" status off
tmux set-option -t "$sid" remain-on-exit off
tmux set-option -t "$sid" pane-border-lines single
tmux set-option -t "$sid" pane-border-status top
tmux set-option -t "$sid" pane-border-format " $dir_name "

# 后台回填:轮询 json 取 claude 会话名并改名(目标名已存在则保留占位名)。
# pane 边框恒为文件夹名(见上),此处只改会话名,不动边框。
(
  sf="$sessions_dir/$pp.json"
  for _ in $(seq 1 50); do
    if [ -r "$sf" ]; then
      j=$(<"$sf")
      case "$j" in
        *'"name":"'*) nm="${j#*\"name\":\"}"; nm="${nm%%\"*}" ;;
        *)            nm="" ;;
      esac
      if [ -n "$nm" ]; then
        if ! tmux has-session -t "${prefix}${nm}" 2>/dev/null; then
          tmux rename-session -t "$sid" "${prefix}${nm}" 2>/dev/null
        fi
        break
      fi
    fi
    sleep 0.1
  done
) &

tmux display-popup -w "$w" -h "$h" -E "tmux attach-session -t '$sid'"
