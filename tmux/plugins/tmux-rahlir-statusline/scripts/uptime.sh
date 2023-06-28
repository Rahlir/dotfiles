#!/usr/bin/env zsh

uptime_raw=$(uptime -p 2>&1)

if [ $? -eq 0 ]; then
    echo -n $uptime_raw | sed 's/up //; s/,//g; s/ days\?/d/; s/ hours\?/h/; s/ minutes\?/m/; s/ weeks\?/w/'
else
    echo -n error
fi
