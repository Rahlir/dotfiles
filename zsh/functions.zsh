function color-sample() {
    for col in "$@"; do
        printf "\x1b[38;5;${col}mxxxxxxx\x1b[0m\n"
    done
}

function lscolors() {
    for ls_color in ${(s.:.)LS_COLORS[@]}; do
        color=${ls_color##*=}
        ext=${ls_color%%=*}
        printf "\e[${color}m${ext}\e[0m " # echo color and extension
    done
    echo
}

function rsync-short() {
    rsync -ahv --partial --progress --timeout=5 "$@"
}

function switch-background() {
    if [[ $SHLVL != 1 ]]; then
        echo "You seem to be in a subshell, run change-background from top-level shell"
        return 1
    elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        echo "You seem to be connected over ssh, change background on your local machine"
        return 1
    fi

    local alacritty_configdir="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"

    if [[ -n "$THEMEBG" ]]; then
        local newbg=$([[ $THEMEBG == dark ]] && echo light || echo dark)
    else
        # THEMEBG variable should be set. Nevertheless, if it is not,
        # try to infer the current background from alacritty theme file used
        if ! [[ -f "$alacritty_configdir/theme.yml" ]]; then
            echo "THEMEBG variable is not set and alacritty theme file could not be found"
            return 1
        fi
        local isdark=$(head -n 1 "$alacritty_configdir/theme.yml" | grep -c dark)
        local islight=$(head -n 1 "$alacritty_configdir/theme.yml" | grep -c light)
        if (( isdark == 1 )); then
            local newbg=light
        elif (( islight == 1 )); then
            local newbg=dark
        else
            echo "Could not infer theme bg from alacritty theme file"
            return 1
        fi
    fi

    local theme_relpath="themes/gruvbox_$newbg.yml"
    ln -fs "$theme_relpath" "$alacritty_configdir/theme.yml" && 
        touch "$alacritty_configdir/alacritty.yml" &&
        export THEMEBG=$newbg && export BAT_THEME=gruvbox-$newbg &&
        source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/p10k.zsh

    local gtkconfig=${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini
    if [[ -f "$gtkconfig" ]]; then
        [[ "$newbg" == "dark" ]] && local gtk_varvalue="true" || local gtk_varvalue="false"
        grep -q "gtk-application-prefer-dark-theme" $gtkconfig && \
            sed -E "s/(gtk-application-prefer-dark-theme[[:space:]]?=[[:space:]]?)(true|false)/\1${gtk_varvalue}/" -i $gtkconfig || \
            echo "gtk-application-prefer-dark-theme = $gtk_varvalue" >> $gtkconfig
    fi

    if [[ "$(uname -s)" == Linux ]]; then
        if [[ "$XDG_SESSION_TYPE" == wayland ]]; then
            gsettings set org.gnome.desktop.interface color-scheme "prefer-$newbg"
        fi
        local wallpaper_path=$HOME/Pictures/.wallpaper
        ln -fs "Wallpapers/archgruv_$newbg.jpg" $wallpaper_path
        if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/sway/theme.conf ]]; then
            ln -fs "themes/gruvbox_$newbg.conf" ${XDG_CONFIG_HOME:-$HOME/.config}/sway/theme.conf
            if [[ -n "$SWAYSOCK" ]]; then
                swaymsg reload
            fi
        fi
    fi
}
