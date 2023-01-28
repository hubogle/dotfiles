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
    local L_BYTES="${1:-0}"
    local L_BASE="${2:-1024}"
    (awk -v bytes="${L_BYTES}" -v base="${L_BASE}" 'function human(x, base) {
         if(base!=1024)base=1000
         s="BKMGTEPYZ"
         while (x>=base && length(s)>1)
               {x/=base; s=substr(s,2)}
         s=substr(s,1,1)
         xf=((s=="B")?"%4d": (x > 99 ? "%4d" : "%4.1f"))
         return sprintf( (xf "%s\n"), x, s)
      }
      BEGIN{print human(bytes, base)}')
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
    echo "${speed}/s"
}

# $1: tx_bytes/rx_bytes
# $2: format
main() {
    printf "${2:-%8s}" "$(get_speed "$1")"
}

main "$@"
