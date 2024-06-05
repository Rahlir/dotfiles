#!/usr/bin/zsh

for id in $@; do
    wait_date=$(task _get $id.wait)
    if [[ -n "$wait_date" ]]; then
        task rc.verbose=nothing $id mod wait:
    else
        task rc.verbose=nothing $id mod wait:later
    fi
done
