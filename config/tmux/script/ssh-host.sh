#!/usr/bin/env bash

pane_pid="$1"

if [ -z "$pane_pid" ]; then
    exit 0
fi

ssh_pid=$(pgrep -P "$pane_pid" ssh | head -n1)
[ -z "$ssh_pid" ] && exit 0

cmd=$(ps -o args= -p "$ssh_pid")

host=$(echo "$cmd" | awk '{
    for (i=1; i<=NF; i++) {
        if ($i == "ssh") continue
        if ($i ~ /^-/) continue
        print $i
        exit
    }
}')

[ -z "$host" ] && exit 0

ip=$(getent ahosts "$host" | awk 'NR==1{print $1}')
[ -z "$ip" ] && ip="$host"

echo "$ip"