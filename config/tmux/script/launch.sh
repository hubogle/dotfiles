#!/usr/bin/env bash
set -uo pipefail

tmux_get() {
  local v
  v="$(tmux show-option -gqv "$1" 2>/dev/null)"
  printf '%s' "${v:-$2}"
}

path="${1:-$PWD}"
window="${2:-}"
origin_session="${3:-}"

prefix="$(tmux_get @claude_session_prefix 'claude-')"
cmd="$(tmux_get @claude_command 'claude')"
w="$(tmux_get @claude_popup_width '90%')"
h="$(tmux_get @claude_popup_height '90%')"

session="${prefix}$(printf '%s\n' "$path" | md5sum | cut -c1-8)"

if [[ "$origin_session" == "$prefix"* ]]; then
    tmux display-message "Claude popup already open"
    exit 0
fi

if ! tmux has-session -t "$session" 2>/dev/null; then
  dir_name="${path%/}"
  dir_name="${dir_name##*/}"

  tmux new-session -d -s "$session" -n claude -c "$path" \
    "zsh -ic 'exec $cmd'"

  tmux set-hook -t "$session" pane-exited "kill-session"

  tmux set-option -t "$session" status off
  tmux set-option -t "$session" remain-on-exit off
  tmux set-option -t "$session" pane-border-lines single
  tmux set-option -t "$session" pane-border-status top
  tmux set-option -t "$session" pane-border-format " $dir_name "
fi

tmux display-popup \
  -w "$w" \
  -h "$h" \
  -E "tmux attach-session -t \"$session\""