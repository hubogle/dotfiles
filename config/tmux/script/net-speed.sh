#!/usr/bin/env bash

# https://github.com/wfxr/tmux-net-speed
# SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# source "$SDIR/helpers.sh"

# $1: rx_bytes 下载，tx_bytes 上传
get_bytes() {
    netstat -ibn | sort -u -k1,1 | grep ':' | grep -Ev '^(lo|docker).*' |
                awk '{rx += $7;tx += $10;}END{print "rx_bytes "rx,"\ntx_bytes "tx}' |
                grep "$1" | awk '{print $2}'
}

# ref: https://unix.stackexchange.com/a/98790 @John
bytestohuman() {
    local bytes="${1:-0}"
    local base="${2:-1024}"
    awk -v bytes="$bytes" -v base="$base" '
    function human(x) {
        s="BKMGTPEZY"; i=0
        while (x >= base && i < length(s)) {x /= base; i++}
        fmt = (i == 0 ? "%d%c" : "%4.1f%c")
        printf(fmt, x, substr(s, i+1, 1))
    }
    BEGIN { human(bytes) }
    '
}

# $1: rx_bytes/tx_bytes
get_speed() {
    local pre cur diff speed pre_var
    pre=$(get_bytes "$1")
    sleep 1
    cur=$(get_bytes "$1")
    diff=$((cur - pre))
    (( diff < 0 )) && diff=0
    speed=$(bytestohuman $diff)
    echo "${speed}"
}

# $1: tx_bytes/rx_bytes
# $2: format
main() {
    printf "${2:-%8s}" "$(get_speed "$1")"
}

main "$@"
