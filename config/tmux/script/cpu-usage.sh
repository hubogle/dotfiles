#!/bin/bash

# idle 在末尾 3 列负载均值之前，用 NF 定位以兼容多磁盘时的列偏移
cpu_usage=$(iostat -c 2 | tail -n 1 | awk '{printf "%2d%%\n", 100 - int($(NF-3))}')

echo "$cpu_usage"
