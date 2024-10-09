##################################################
###                Setting PATH                ###
##################################################
# Prepend "$1" to $PATH when not already in.
# Based on function in /etc/profile on ArchLinux
prepend_path () {
    case ":$PATH:" in
        *:"$1":*)
            case "$PATH" in
                "$1":*)
                    ;;
                *)
                    export PATH="$1":"${PATH//:"$1"/}"
                    ;;
            esac
            ;;
        *)
            export PATH="$1${PATH:+:$PATH}"
    esac
}

prepend_path "$HOME/.local/bin"

##################################################
###              OS Specific ENVs              ###
##################################################
if [ "$(uname -s)" = Darwin ]; then
    if command -v brew &> /dev/null; then
        eval "$(brew shellenv)"
    elif [ -x "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    if [ -n "$HOMEBREW_PREFIX" ]; then
        export PKG_PREFIX=$HOMEBREW_PREFIX
        [ -d "$PKG_PREFIX"/opt/coreutils/libexec/gnubin ] && \
            prepend_path "$PKG_PREFIX"/opt/coreutils/libexec/gnubin
        [ -d "$PKG_PREFIX"/opt/gnu-sed/libexec/gnubin ] && \
            prepend_path "$PKG_PREFIX"/opt/gnu-sed/libexec/gnubin
    fi
elif [ "$(uname -s)" = Linux ]; then
    export PKG_PREFIX=/usr
fi

##################################################
###                    LANG                    ###
##################################################
test -n "${LANG:+1}" || export LANG=en_US.UTF-8

##################################################
###            XDG Base Directories            ###
##################################################
export XDG_CONFIG_HOME="$HOME/.config"
test -d "$XDG_CONFIG_HOME" || mkdir "$XDG_CONFIG_HOME"
export XDG_DATA_HOME="$HOME/.local/share"
test -d "$XDG_DATA_HOME" || mkdir -p "$XDG_DATA_HOME"
export XDG_STATE_HOME="$HOME/.local/state"
test -d "$XDG_STATE_HOME" || mkdir "$XDG_STATE_HOME"
export XDG_CACHE_HOME="$HOME/.cache"
test -d "$XDG_CACHE_HOME" || mkdir "$XDG_CACHE_HOME"

##################################################
###            Other ENV Variables             ###
##################################################
# Setting up default editor
if command -v nvim &> /dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
elif command -v vim &> /dev/null; then
    export EDITOR=vim
    export VISUAL=vim
else
    export EDITOR=vi
    export VISUAL=vi
fi

if test -n "$WAYLAND_DISPLAY" || test -n "$DISPLAY"; then
    export BROWSER=firefox
elif test "$(uname -s)" != Darwin; then
    export BROWSER=lynx
fi

# Path to dotfiles
export DOTDIR="$HOME/.dotfiles"
# LESS history file
test -d "$XDG_STATE_HOME/less" || mkdir "$XDG_STATE_HOME/less"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
# GNU Parallel data directory
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
# GNU Readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
# Terminfo directories
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

test -r "$HOME"/.profile_local && source "$HOME"/.profile_local
