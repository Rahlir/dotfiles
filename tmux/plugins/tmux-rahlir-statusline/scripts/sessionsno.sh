#!/usr/bin/env zsh

sessions=$(tmux list-sessions | wc -l)

if (( $sessions > 1 )); then
    echo -n "$sessions sessions"
else
    echo -n "$sessions session"
fi
