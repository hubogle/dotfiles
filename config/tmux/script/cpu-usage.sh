#!/bin/bash
# 获取当前CPU使用率 (user + system)，保留1位小数，带百分号

cpu_usage=$(top -l 1 | grep 'CPU usage' | awk '{printf "%.1f%%", $3+$5}')
echo "$cpu_usage"
