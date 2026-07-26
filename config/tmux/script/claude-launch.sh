#!/usr/bin/env bash
# 在 Claude Code 专用 hub session（默认 claude）中新建一个 window。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/claude-lib.sh"

path="${1:-$PWD}"
# claude-launch.sh <path> <client>。旧绑定传的是 <path> <session_name> <client>
# 且 session_name 从未被用到——第三个参数还在就说明 tmux.conf 尚未 reload。
origin_client="${2:-}"
[ -n "${3:-}" ] && origin_client="$3"
cmd="$(claude_command)"
hub="$(claude_hub_session)"
sessions_dir="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/sessions}"

# popup 已经开着、这一下又是从 popup 里按的:那里的 pane_current_path 是 $HOME,
# 照常新建只会开出一个 home 目录的 Claude Code。此时 O 与 C-p 同义——收起 popup。
# 判据是按键来自哪个 client,而不是"popup 是否显示":别的 client 在自己的项目
# 目录里按 O 仍然要新建,只是复用已显示的 popup(见 claude-tui.sh)。
if client_inside_popup "$origin_client"; then
  exec "$script_dir/claude-tui.sh" "$origin_client" --toggle
fi

if tmux has-session -t "$hub" 2>/dev/null; then
  out="$(tmux new-window -d -P -F '#{window_id} #{pane_pid}' -t "$hub" -c "$path" "zsh -ic 'exec $cmd'")"
  read -r window_id pane_pid <<<"$out"
else
  out="$(tmux new-session -d -P -F '#{session_id} #{window_id} #{pane_pid}' -s "$hub" -c "$path" "zsh -ic 'exec $cmd'")"
  read -r _ window_id pane_pid <<<"$out"
fi

# hub 只在 popup 里以嵌套 client 的形式露面,自己的状态栏永远不该出现。
# 在这里一次性关掉(幂等,也顺带修好本改动之前建好的 hub),popup 的显示/隐藏
# 就不必再去保存-关闭-还原它。
tmux set-option -t "$hub" status off 2>/dev/null || true

# 窗口名直接用目录名。Claude 的 session 名就是这个目录的 basename(可能再带一个
# 消歧后缀,列表侧会剥掉),启动时路径已经知道,没有理由先挂一个 claude-<pid>
# 再等下面的 json 轮询改名——那会让列表在几秒内换一次名字。
dir_name="${path%/}"; dir_name="${dir_name##*/}"
tmux rename-window -t "$window_id" "${dir_name:-claude-$pane_pid}"
tmux set-window-option -t "$window_id" @claude_window 1
tmux set-window-option -t "$window_id" remain-on-exit off
tmux set-hook -t "$window_id" pane-exited "kill-window -t '$window_id'"

(
  session_file="$sessions_dir/$pane_pid.json"
  for _ in $(seq 1 50); do
    if [ -r "$session_file" ]; then
      json=$(<"$session_file")
      case "$json" in
        *'"name":"'*) name="${json#*\"name\":\"}"; name="${name%%\"*}" ;;
        *) name="" ;;
      esac
      [ -n "$name" ] && tmux rename-window -t "$window_id" "$name" 2>/dev/null && break
    fi
    sleep 0.1
  done
) &

# 创建后直接交给 popup 管理器展示。selected window id 让左侧列表准确
# 选中刚创建的 Claude Code，而无需先切入 hub session。
exec "$script_dir/claude-tui.sh" "$origin_client" "$window_id"
