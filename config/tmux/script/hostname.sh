#!/usr/bin/env bash

get_info() {
  if ssh_connected; then
    local cmd=$({ pgrep -flaP `tmux display-message -p "#{pane_pid}"` ; ps -o command -p `tmux display-message -p "#{pane_pid}"` ; } | grep ssh | sed -E 's/^[0-9]*[[:blank:]]*ssh //')
    echo $cmd
  fi
}

ssh_connected() {
  local cmd=$(tmux display-message -p "#{pane_current_command}")

  [ $cmd = "ssh" ] || [ $cmd = "sshpass" ]
}

get_info
