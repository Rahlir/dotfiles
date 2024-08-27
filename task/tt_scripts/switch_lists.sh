#!/usr/bin/env zsh

for id in $@; do
    agilestatus=$(task _get $id.agilestatus)
    if [[ $agilestatus == "active" ]]; then
        task rc.verbose=nothing $id mod agilestatus:backlog
    else
        task rc.verbose=nothing $id mod agilestatus:active -nextweek
    fi
done
