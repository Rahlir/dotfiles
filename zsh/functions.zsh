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
        print -P "%B%F{red}Error:%b%f You seem to be in a subshell, run switch-background from top-level shell."
        return 1
    elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        print -P "%B%F{red}Error:%b%f You seem to be connected over ssh, switch-background on your local machine."
        return 1
    elif [[ ! -v THEMENAME ]]; then
        print -P "%B%F{red}Error:%b%f THEMENAME variable is not set."
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
        local isdark=$(tail -n 1 "$alacritty_configdir/theme.toml" | grep -c dark)
        local islight=$(tail -n 1 "$alacritty_configdir/theme.toml" | grep -c light)
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
    [[ "$newbg" == "dark" ]] && local gtk_theme="${(C)THEMENAME}-Dark-Borderless" || local gtk_theme="${(C)THEMENAME}-Light-Borderless"

    local theme_relpath="themes/${THEMENAME}_$newbg.toml"
    ln -fs "$theme_relpath" "$alacritty_configdir/theme.toml" &&
        touch "$alacritty_configdir/alacritty.toml" &&
        export THEMEBG=$newbg && export BAT_THEME=gruvbox-$newbg &&
        source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/p10k.zsh

    local gtkconfig=${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini
    if [[ -f "$gtkconfig" ]]; then
        grep -q "gtk-application-prefer-dark-theme" $gtkconfig && \
            sed -E "s/(gtk-application-prefer-dark-theme[[:space:]]?=[[:space:]]?)(true|false)/\1${darkmode_bool}/" -i $gtkconfig || \
            echo "gtk-application-prefer-dark-theme = $darkmode_bool" >> $gtkconfig
        grep -q "gtk-theme-name" $gtkconfig && \
            sed -E "s/(gtk-theme-name[[:space:]]?=[[:space:]]?)(${(C)THEMENAME}-(Dark|Light)-Borderless)/\1${gtk_theme}/" -i $gtkconfig || \
            echo "gtk-theme-name = $gtk_theme" >> $gtkconfig
        grep -q "gtk-icon-theme-name" $gtkconfig && \
            sed -E "s/(gtk-icon-theme-name[[:space:]]?=[[:space:]]?)(${(C)THEMENAME}-(Dark|Light))/\1${gtk_theme%-*}/" -i $gtkconfig || \
            echo "gtk-icon-theme-name = ${gtk_theme%-*}" >> $gtkconfig
    fi
    if [[ -d ${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/colors/ ]]; then
        ln -fs "colors/${THEMENAME}-$newbg.css" ${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/colors.css
    fi
    if [[ -d ${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0/colors/ ]]; then
        ln -fs "colors/${THEMENAME}-$newbg.css" ${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0/colors.css
    fi

    if [[ "$(uname -s)" == Linux ]]; then
        if [[ "$XDG_SESSION_TYPE" == wayland ]]; then
            gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme
            gsettings set org.gnome.desktop.interface icon-theme ${gtk_theme%-*}
            gsettings set org.gnome.desktop.interface color-scheme prefer-$newbg
        fi

        if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/mako/config ]]; then
            ln -fs "${THEMENAME}_$newbg" ${XDG_CONFIG_HOME:-$HOME/.config}/mako/config
            (( $+commands[makoctl] )) && makoctl reload
        fi

        if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/hypr/theme.conf ]]; then
            ln -fs "themes/${THEMENAME}_$newbg.conf" ${XDG_CONFIG_HOME:-$HOME/.config}/hypr/theme.conf
            if hypr_instances=$(hyprctl instances 2> /dev/null); then
                if [[ -n $hypr_instances ]]; then
                    hyprctl reload &> /dev/null
                    systemctl is-active --user waybar.service &> /dev/null && \
                        systemctl restart --user waybar.service
                fi
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
    if [[ -n $plug ]]; then
        plug+=";";
    fi
    plug+="s:!git s;l:!git lg"
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
