#!/usr/bin/env zsh

if raw_output=$(sensors -u 2>&1); then
    temp=$(echo $raw_output | grep temp1_input | head -n1 | tr -d ' ' | cut -d ':' -f2 | sed 's/\([0-9]\+\.[0-9]\)[0-9]*/\1/')
    echo -n "$temp"°C
elif raw_output=$(osx-cpu-temp 2>&1); then
    echo -n $raw_output
else
    echo -n Error
fi
