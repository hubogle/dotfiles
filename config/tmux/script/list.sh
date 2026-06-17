#!/usr/bin/env bash
set -uo pipefail

prefix="${CLAUDE_SESSION_PREFIX:-claude-}"

tmux_get() {
  local v
  v="$(tmux show-option -gqv "$1" 2>/dev/null)"
  printf '%s' "${v:-$2}"
}

emit_rows() {
  local now s state at path icon rank ago dir
  now=$(date +%s)

  tmux list-sessions -F '#{session_name}' 2>/dev/null |
    grep "^${prefix}" |
    while IFS= read -r s; do
      state=$(tmux show-options -qv -t "$s" @claude_state 2>/dev/null)
      at=$(tmux show-options -qv -t "$s" @claude_state_at 2>/dev/null)
      path=$(tmux display-message -p -t "$s" '#{pane_current_path}' 2>/dev/null)
      dir="${path##*/}"

      case "$state" in
          permission) icon=$'\033[35m●\033[0m permit '; rank=0 ;;
          waiting)    icon=$'\033[33m●\033[0m waiting'; rank=1 ;;
          idle)       icon=$'\033[32m●\033[0m idle   '; rank=2 ;;
          working)    icon=$'\033[31m●\033[0m working'; rank=3 ;;
          *)          icon=$'\033[90m●\033[0m   ?    '; rank=4 ;;
      esac

      if [ -n "$at" ]; then ago="$(( (now - at) / 60 ))m"; else ago='-'; fi
      printf '%s\t%s\t%s %s %s\n' "$rank" "$s" "$icon" "$dir" "$ago"
    done |
    sort -n
}

nested_session() {
  tmux list-clients -F '#{client_name} #{session_name}' 2>/dev/null |
    awk -v p="$prefix" 'index($2, p) == 1 { print $2; exit }'
}

host_client() {
  tmux list-clients -F '#{client_name} #{session_name}' 2>/dev/null |
    awk -v p="$prefix" 'index($2, p) != 1 { print $1; exit }'
}

run_picker() {
  if ! command -v fzf >/dev/null 2>&1; then
    tmux display-message "tmux-claude-session-manager: fzf is required for the picker"
    exit 0
  fi

  local self sel target origin parent
  self="${BASH_SOURCE[0]}"

  sel=$(emit_rows | fzf --ansi \
    --reverse --cycle \
    --delimiter=$'\t' \
    --with-nth=3 \
    --preview='tmux capture-pane -ept {2}' \
    --preview-window='right,80%,wrap' \
    --bind='ctrl-r:refresh-preview'
    --bind="ctrl-x:execute-silent(tmux kill-session -t {2})+reload($self --list)")

  [ -z "$sel" ] && exit 0
  target=$(printf '%s' "$sel" | cut -f2)

  origin=$(tmux show-options -qv -t "$target" @claude_origin 2>/dev/null)
  parent=$(tmux show-options -gqv @claude_parent 2>/dev/null)

  [ -n "$origin" ] && [ -n "$parent" ] &&
    tmux switch-client -c "$parent" -t "$origin" 2>/dev/null

  tmux attach-session -t "$target"
}

open_popup() {
  local w h sess host

  w="$(tmux_get @claude_popup_width '90%')"
  h="$(tmux_get @claude_popup_height '90%')"

  sess="$(nested_session)"
  if [ -n "$sess" ]; then
    tmux detach-client -s "$sess"
    for _ in $(seq 1 100); do
      [ -z "$(nested_session)" ] && break
      sleep 0.05
    done
  fi

  host="$(host_client)"
  tmux set-option -g @claude_parent "$host"

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