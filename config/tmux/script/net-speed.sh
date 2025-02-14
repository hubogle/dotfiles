#!/usr/bin/env bash


if [ -z "${INTERFACE_CACHE:-}" ]; then
  INTERFACE_CACHE=$(route get default 2>/dev/null | awk '/interface/ {print $2}')
fi
iface="$INTERFACE_CACHE"

if [ -z "$iface" ]; then
  echo "  0.0B"
  exit 0
fi

# iface="en0"

# get_bytes_in() {
#   nettop -l 1 -J interface,bytes_in -x | awk -v iface="$iface" '
#     NF >= 2 && $(NF-1) == iface { sum += $NF }
#     END { print sum }
#   '
# }

get_bytes_in() {
	netstat -ib | awk -v iface="$iface" '$1==iface { sum += $7 } END { print sum }'
}

prev=$(get_bytes_in)
sleep 1

size=$(( $(get_bytes_in) - prev ))
if [ "$size" -lt 0 ]; then
  echo "  0.0B"
  exit 0
fi

speed=""
units=("B" "K" "M" "G")
i=0

while [ "$size" -ge 1024 ] && [ "$i" -lt 3 ]; do
  size=$((size / 1024))
  i=$((i + 1))
done

if [ "$size" -ge 100 ]; then
  speed=$(printf "%5.0f%s" "$size" "${units[$i]}")
else
  speed=$(printf "%5.1f%s" "$size" "${units[$i]}")
fi

echo "$speed"