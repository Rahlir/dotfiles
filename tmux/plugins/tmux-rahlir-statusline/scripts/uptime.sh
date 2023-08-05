#!/usr/bin/env zsh

if ! (( $+commands[uptime] )); then
    echo -n "error"
fi

if uptime_raw=$(uptime -p 2>&1); then
    echo -n $uptime_raw | sed 's/up //; s/,//g; s/ days\?/d/; s/ hours\?/h/; s/ minutes\?/m/; s/ weeks\?/w/'
elif (( $(uptime | tr ',' '\n' | wc -l) == 5 )); then
    uptime_raw=$(uptime | cut -d ',' -f1 )
    days=$(echo $uptime_raw | sed -nE 's/^.*up ([[:digit:]]+) day(s)?.*/\1/p')
    hours=$(echo $uptime_raw | sed -nE 's/^.* ([[:digit:]]{1,2}):[[:digit:]]{2}/\1/p')
    minutes=$(echo $uptime_raw | sed -nE 's/^.* [[:digit:]]{1,2}:([[:digit:]]{2})/\1/p' | sed 's/^0//')
    final_str=""
    (( $days )) && final_str+="${days}d"
    (( $hours )) && final_str+="${final_str:+ }${hours}h"
    (( $minutes )) && final_str+="${final_str:+ }${minutes}m"
    echo -n $final_str
else
    echo -n "error"
fi
