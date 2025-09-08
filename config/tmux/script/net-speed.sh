#!/usr/bin/env bash

bytes_in=$(
  netstat -w 1 -b -I en0 2>/dev/null | awk 'NR==3 {print $3; exit}'
)

if [[ -z "${bytes_in:-}" ]]; then
  bytes_in=0
fi

awk -v b="$bytes_in" '
  function human(n,u,i){
    split("B K M G T",u," "); i=1
    while(n>=1024 && i<5){ n/=1024; i++ }
    if (n >= 100) {
      printf("%4.0f%s\n", n, u[i])
    } else {
      printf("%4.1f%s\n", n, u[i])
    }
  }
  BEGIN{ human(b+0) }
'
