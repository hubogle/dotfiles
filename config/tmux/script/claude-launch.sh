#!/usr/bin/env bash
# 在弹窗中新开一个 claude 会话:launch.sh <path> <origin_session> <origin_client>
set -uo pipefail

source "${BASH_SOURCE[0]%/*}/claude-lib.sh"

path="${1:-$PWD}"
origin_session="${2:-}"
origin_client="${3:-}"

prefix="$(tmux_get @claude_session_prefix "${CLAUDE_SESSION_PREFIX:-claude-}")"
cmd="$(claude_command)"
w="$(tmux_get @claude_popup_width '100%')"
h="$(tmux_get @claude_popup_height '100%')"
sessions_dir="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/sessions}"

# 已经在 claude 弹窗里,不允许再嵌套开一个
if [[ "$origin_session" == "$prefix"* ]]; then
    tmux display-message "Claude popup already open"
    exit 0
fi

# 新建会话运行 claude:exec 使 pane_pid 即 claude 进程 pid,
# 对应注册表文件 ~/.claude/sessions/<pid>.json。
# 先用 claude-<pid> 占位命名,后台等 json 写入 name 后再改名;
# 全程按 session_id 寻址,改名与 attach 互不干扰
out=$(tmux new-session -d -c "$path" -P -F '#{session_id} #{pane_pid}' "zsh -ic 'exec $cmd'")
read -r sid pp <<<"$out"

tmux rename-session -t "$sid" "${prefix}${pp}" 2>/dev/null

# popup 内的 Claude client 需要知道自己来自哪个外层 client；列表快捷键从该 popup
# 再次打开时据此精确回到原终端，而不是影响其他 tmux 客户端。
[ -n "$origin_client" ] && tmux set-option -t "$sid" @claude_host_client "$origin_client"

tmux set-hook   -t "$sid" pane-exited "kill-session"
tmux set-option -t "$sid" status off
tmux set-option -t "$sid" remain-on-exit off

# 后台回填:轮询 json 取 claude 会话名并改名(目标名已存在则保留占位名)。
# 只改会话名；popup 内不显示 pane 标题栏，避免持续重绘时露出底层内容。
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

if [ -n "$origin_client" ]; then
  claude_popup_dims "$origin_client" "$w" "$h" # -> REPLY=宽 REPLY2=高，100% 高度预留顶部状态栏
  # Claude 画面持续重绘时，tmux 的 popup 边框会单独刷新；在带透明度的
  # Alacritty 中会短暂露出底层 pane。与其他 fzf popup 保持一致，直接无框显示。
  tmux display-popup -b none -c "$origin_client" -w "$REPLY" -h "$REPLY2" -y S -E "tmux attach-session -t '$sid'"
else
  tmux display-popup -b none -w "$w" -h "$h" -y S -E "tmux attach-session -t '$sid'"
fi
