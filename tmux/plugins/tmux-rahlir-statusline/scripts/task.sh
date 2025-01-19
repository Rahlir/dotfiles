#!/usr/bin/env zsh

if ! (( $+commands[task] )); then
    echo -n "error"
fi

filter=$(tmux show-option -gv @task-filter 2> /dev/null || echo -n +PENDING)

task rc.color=0 rc.verbose=nothing $filter count || echo -n "error"
