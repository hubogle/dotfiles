#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

HOSTS="baidu.com google.com"

get_ssid()
{
  if /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2 | sed 's/ ^*//g' &> /dev/null; then
    # echo "$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2)" | sed 's/ ^*//g'
    echo "WIFI"
  else
    echo 'Ethernet'
  fi
}

main()
{
  network="Offline"
  for host in $HOSTS; do
    if ping -q -c 1 -W 1 $host &>/dev/null; then
      network="$(get_ssid)"
      break
    fi
  done

  echo "$network"
}

#run main driver function
main
