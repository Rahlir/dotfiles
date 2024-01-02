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
        echo "You seem to be in a subshell, run switch-background from top-level shell"
        return 1
    elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        echo "You seem to be connected over ssh, switch-background on your local machine"
        return 1
    fi

    local alacritty_configdir="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"

    if [[ -n "$THEMEBG" ]]; then
        local newbg=$([[ $THEMEBG == dark ]] && echo light || echo dark)
    else
        # THEMEBG variable should be set. Nevertheless, if it is not,
        # try to infer the current background from alacritty theme file used
        if ! [[ -f "$alacritty_configdir/theme.toml" ]]; then
            echo "THEMEBG variable is not set and alacritty theme file could not be found"
            return 1
        fi
        local isdark=$(head -n 1 "$alacritty_configdir/theme.toml" | grep -c dark)
        local islight=$(head -n 1 "$alacritty_configdir/theme.toml" | grep -c light)
        if (( isdark == 1 )); then
            local newbg=light
        elif (( islight == 1 )); then
            local newbg=dark
        else
            echo "Could not infer theme bg from alacritty theme file"
            return 1
        fi
    fi

    [[ "$newbg" == "dark" ]] && local darkmode_bool="true" || local darkmode_bool="false"

    local theme_relpath="themes/gruvbox_$newbg.toml"
    ln -fs "$theme_relpath" "$alacritty_configdir/theme.toml" &&
        touch "$alacritty_configdir/alacritty.toml" &&
        export THEMEBG=$newbg && export BAT_THEME=gruvbox-$newbg &&
        source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/p10k.zsh


    local gtkconfig=${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini
    if [[ -f "$gtkconfig" ]]; then
        grep -q "gtk-application-prefer-dark-theme" $gtkconfig && \
            sed -E "s/(gtk-application-prefer-dark-theme[[:space:]]?=[[:space:]]?)(true|false)/\1${darkmode_bool}/" -i $gtkconfig || \
            echo "gtk-application-prefer-dark-theme = $darkmode_bool" >> $gtkconfig
    fi

    if [[ "$(uname -s)" == Linux ]]; then
        if [[ "$XDG_SESSION_TYPE" == wayland ]]; then
            gsettings set org.gnome.desktop.interface color-scheme "prefer-$newbg"
        fi
        local wallpaper_path=$HOME/Pictures/.wallpaper
        ln -fs "Wallpapers/archgruv_$newbg.jpg" $wallpaper_path
        if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/tofi/theme ]]; then
            ln -fs "themes/gruvbox_$newbg" ${XDG_CONFIG_HOME:-$HOME/.config}/tofi/theme
        fi
        if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/sway/swaylock.conf ]]; then
            ln -fs "swaylock/gruvbox_$newbg" ${XDG_CONFIG_HOME:-$HOME/.config}/sway/swaylock.conf
        fi
        if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/mako/config ]]; then
            ln -fs "gruvbox_$newbg" ${XDG_CONFIG_HOME:-$HOME/.config}/mako/config
        fi
        if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/sway/theme.conf ]]; then
            ln -fs "themes/gruvbox_$newbg.conf" ${XDG_CONFIG_HOME:-$HOME/.config}/sway/theme.conf
            if [[ -n "$SWAYSOCK" ]]; then
                swaymsg reload && makoctl reload
            fi
        fi
    elif [[ "$(uname -s)" == Darwin ]]; then
        osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to ${darkmode_bool}"
    fi
}

function n()
{
    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return 1
    fi

    # To cd on quit only on ^G, don't use "export" and make sure not to
    # use a custom path
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    local blk="0B" chr="03" dir="04" exe="05" reg="00"
    local hardlink="0a" symlink="02" missing="08" orphan="09" fifo="d0" sock="0d" other="01"
    local plug
    if [[ -x ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/gitroot ]]; then
        plug+="g:gitroot"
    fi
    if [[ -x ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/fzopen ]]; then
        plug+=";f:fzopen"
    fi
    if [[ -x ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/diffs ]]; then
        plug+=";d:diffs"
    fi
    if [[ -x ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/fzopen && -n $TMUX ]]; then
        plug+=";p:preview-tui"
        set -- "-a" "$@"
    fi
    plug+=";s:!git s;l:!git lg"
    if [[ -x ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/nuke ]]; then
        [[ -n $SSH_CONNECTION ]] || local gui=${GUI:-1}
        NNN_OPENER="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/nuke" GUI=${gui:-0}\
            NNN_FCOLORS="$blk$chr$dir$exe$reg$hardlink$symlink$missing$orphan$fifo$sock$other" \
            NNN_COLORS="#0e0d0c0a" \
            NNN_BMS="d:$HOME/Development;o:$HOME/Documents;w:$HOME/Downloads;s:$HOME/Software;t:$DOTDIR;n:$HOME/Documents/rahlir-notes" \
            NNN_ORDER="t:$HOME/Downloads;t:$ZK_NOTEBOOK_DIR" NNN_PLUG=$plug \
            \nnn -cd $@
    else
        NNN_FCOLORS="$blk$chr$dir$exe$reg$hardlink$symlink$missing$orphan$fifo$sock$other" \
            NNN_COLORS="#0e0d0c0a" \
            NNN_BMS="d:$HOME/Development;o:$HOME/Documents;w:$HOME/Downloads;s:$HOME/Software;t:$DOTDIR;n:$HOME/Documents/rahlir-notes" \
            NNN_ORDER="t:$HOME/Downloads;t:$ZK_NOTEBOOK_DIR" NNN_PLUG=$plug \
            \nnn -ed $@
    fi

    if [[ -f "$NNN_TMPFILE" ]]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
