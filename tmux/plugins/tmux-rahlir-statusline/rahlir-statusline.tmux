#!/usr/bin/env bash

current_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

default_emph_color=brightblue
default_status_color=blue
default_notify_color=cyan
default_right_separator=""
default_left_separator=""
default_inner_separator=" "
default_status_justify=centre

get_tmux_option() {
    local option=$1
    local default_value=$2
    local value="$(tmux show-option -gqv $option)"

    if [[ -z $value ]]; then
        echo "$default_value"
    else
        echo "$value"
    fi
}

replace_commands_statusline() {
    local status_left="$(tmux show-option -gv status-left)"
    local status_right="$(tmux show-option -gv status-right)"
    local script_dir="$current_dir/scripts"
    local interpolate_fields=(
        "\#{uptime}"
        "\#{cputemp}"
        "\#{loadavg}"
        "\#{sessionsno}"
        "\#{memory}"
    )
    local interpolate_cmds=(
        "#($script_dir/uptime.sh)"
        "#($script_dir/cputemp.sh)"
        "#($script_dir/loadavg.sh)"
        "#($script_dir/sessionsno.sh)"
        "#($script_dir/memory.sh)"
    )

    for ((i=0; i<${#interpolate_fields[@]}; i++)); do
        status_left=${status_left//${interpolate_fields[$i]}/${interpolate_cmds[$i]}}
        status_right=${status_right//${interpolate_fields[$i]}/${interpolate_cmds[$i]}}
    done
    tmux set-option -g status-left "$status_left"
    tmux set-option -g status-right "$status_right"
}

style_statusline() {
    local separator_left="$(get_tmux_option @separator-right "$default_left_separator")"
    local separator_left_inner="$(get_tmux_option @separator-left-inner "$default_inner_separator")"
    local color_prefix="$(get_tmux_option @color-prefix "$default_notify_color")"
    local color_left_emph="$(get_tmux_option @color-left-emph "$default_emph_color")"
    local color_left="$(get_tmux_option @color-left "$default_status_color")"

    tmux set-option -g status-style fg="$color_left",bg=black

    local status_left="$(tmux show-option -gv status-left)"
    status_left="#{?client_prefix,#[bg=$color_prefix],#[bg=$color_left_emph]}#[fg=black,bold]$status_left"
    status_left=${status_left/\#\{separator\}/\#\{?client_prefix,\#[fg=$color_prefix],\#[fg=$color_left_emph]\}\#[bg=$color_left,nobold]$separator_left\#[fg=black,bg=$color_left]}
    status_left=${status_left/\#\{separator\}/\#[fg=$color_left,bg=black]$separator_left}
    status_left=${status_left//\#\{separator\}/$separator_left_inner}

    local color_right_emph="$(get_tmux_option @color-right-emph "$default_emph_color")"
    local color_right="$(get_tmux_option @color-right "$default_status_color")"
    local separator_right="$(get_tmux_option @separator-right "$default_right_separator")"
    local separator_right_inner="$(get_tmux_option @separator-right-inner "$default_inner_separator")"

    local status_right="$(tmux show-option -gv status-right)"
    local n_seps="$(echo "$status_right" | grep -o "#{separator}" | wc -l)"
    status_right="#[fg=$color_right,bg=black]$status_right"
    while [ $n_seps -gt 0 ]; do
        if [ $n_seps -gt 2 ]; then
            status_right=${status_right/\#\{separator\}/$separator_right_inner}
        elif [ $n_seps -gt 1 ]; then
            status_right=${status_right/\#\{separator\}/$separator_right\#[fg=black,bg=$color_right]}
        else
            status_right=${status_right/\#\{separator\}/\#[fg=$color_right_emph,bg=$color_right]$separator_right\#[fg=black,bg=$color_right_emph,bold]}
        fi
        n_seps=$(( $n_seps - 1 ))
    done

    tmux set-option -g status-left "$status_left"
    tmux set-option -g status-right "$status_right"
}

style_windowstatus() {
    local window_bg="$(get_tmux_option @window-bg "$default_status_color")"
    local window_fg="$(get_tmux_option @window-fg black)"
    local wactivity_bg="$(get_tmux_option @wactivity-bg "$default_notify_color")"
    local wactivity_fg="$(get_tmux_option @wactivity-fg "$window_fg")"
    local wcurrent_bg="$(get_tmux_option @wcurrent-bg "$default_emph_color")"
    local wcurrent_fg="$(get_tmux_option @wcurrent-fg black)"
    local wlast_fg="$(get_tmux_option @wlast-fg "$window_fg")"
    local wlast_bg="$(get_tmux_option @wlast-bg "$window_bg")"
    
    tmux set-option -g window-status-style fg="$window_fg",bg="$window_bg"
    tmux set-option -g window-status-current-style fg="$wcurrent_fg",bg="$wcurrent_bg",bold
    tmux set-option -g window-status-activity-style fg="$wactivity_fg",bg="$wactivity_bg"
    tmux set-option -g window-status-last-style fg="$wlast_fg",bg="$wlast_bg",italics

    local separator_window_inner="$(get_tmux_option @separator-window-inner "$default_inner_separator")"
    local separator_window_left="$(get_tmux_option @separator-window-left "$default_right_separator")"
    local separator_window_right="$(get_tmux_option @separator-window-right "$default_left_separator")"

    local padding="$(printf '%*s' $((${#separator_window_inner}-1)))"
    local wstatus_format="$(tmux show-option -gv window-status-format)"
    wstatus_format="#{?window_start_flag,#[reverse]$separator_window_left#[default],$padding}$wstatus_format"
    wstatus_format="$wstatus_format#{?window_end_flag,#[reverse]$separator_window_right#[default],${separator_window_inner:0:1}}"

    tmux set-option -g window-status-format "$wstatus_format"
    tmux set-option -g window-status-current-format "#{E:window-status-format}"
    tmux set-option -g window-status-separator ""

    tmux set-option -g status-justify "$(get_tmux_option @status-justify "$default_status_justify")"
}

style_statusline
replace_commands_statusline
style_windowstatus
