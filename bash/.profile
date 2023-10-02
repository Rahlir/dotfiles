##################################################
###                Setting PATH                ###
##################################################
# Prepend "$1" to $PATH when not already in.
# Based on function in /etc/profile on ArchLinux
prepend_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="$1${PATH:+:$PATH}"
    esac
}

prepend_path "$HOME/.local/bin"

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

if test "$(uname -s)" = Darwin; then
    :
elif test -n "$WAYLAND_DISPLAY" || test -n "$DISPLAY"; then
    export BROWSER=firefox
else
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
# Docker config home
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
