#!/usr/bin/env zsh

if ! (( $+commands[uptime] )); then
    echo -n "error"
    exit 1
fi

# Preferred path (GNU-style): "up 1 hour, 5 minutes".
if uptime_line=$(uptime -p 2>&1); then
    echo -n $uptime_line | sed 's/up //; s/,//g; s/ days\?/d/; s/ hours\?/h/; s/ minutes\?/m/; s/ weeks\?/w/'
# macOS fallback: parse classic output, e.g.
# "15:26  up  1:43, 2 users, load averages: ..."
elif uptime_line=$(uptime 2>&1); then
    # Extract only the uptime fragment and drop users/load text.
    uptime_raw=$(echo $uptime_line | sed -nE 's/^.* up[[:space:]]+([^,]+(,[[:space:]]*[^,]+)?),[[:space:]]+[[:digit:]]+[[:space:]]+users?.*$/\1/p')

    # Numeric defaults keep arithmetic checks safe.
    days=0
    hours=0
    minutes=0

    # Parse explicit units first (days/mins/hrs).
    parsed_days=$(echo " $uptime_raw" | sed -nE 's/^.* ([[:digit:]]+) days?.*$/\1/p')
    [[ -n $parsed_days ]] && days=$parsed_days

    parsed_minutes=$(echo " $uptime_raw" | sed -nE 's/^.* ([[:digit:]]+) mins?.*$/\1/p')
    [[ -n $parsed_minutes ]] && minutes=$parsed_minutes

    parsed_hours=$(echo " $uptime_raw" | sed -nE 's/^.* ([[:digit:]]+) hrs?.*$/\1/p')
    [[ -n $parsed_hours ]] && hours=$parsed_hours

    # If HH:MM exists, prefer that for hours/minutes.
    if [[ $uptime_raw =~ [[:digit:]]{1,2}:[[:digit:]]{2} ]]; then
        parsed_hours=$(echo " $uptime_raw" | sed -nE 's/^.* ([[:digit:]]{1,2}):[[:digit:]]{2}.*$/\1/p')
        parsed_minutes=$(echo " $uptime_raw" | sed -nE 's/^.* [[:digit:]]{1,2}:([[:digit:]]{2}).*$/\1/p' | sed 's/^0//')
        [[ -n $parsed_hours ]] && hours=$parsed_hours
        [[ -n $parsed_minutes ]] && minutes=$parsed_minutes
    fi

    # Build compact output and skip zero-value units.
    final_str=""
    (( days )) && final_str+="${days}d"
    (( hours )) && final_str+="${final_str:+ }${hours}h"
    (( minutes )) && final_str+="${final_str:+ }${minutes}m"
    echo -n $final_str
else
    echo -n "error"
fi
