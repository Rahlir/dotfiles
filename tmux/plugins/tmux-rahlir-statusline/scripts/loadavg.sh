#!/usr/bin/env bash

if [[ -f /proc/loadavg ]]; then
    cut -d ' ' -f1,2,3 /proc/loadavg
elif raw_output=$(sysctl -n vm.loadavg 2>&1); then
    echo $raw_output | sed -e 's/^{[[:space:]]//' -e 's/[[:space:]]}$//'
else
    echo "ERROR"
fi
