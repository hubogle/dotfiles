#!/bin/bash

cpu_usage=$(iostat -c 2 | tail -n 1 | awk '{printf "%2d%%\n", 100 - int($6)}')

echo "$cpu_usage"
