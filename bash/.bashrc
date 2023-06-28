# BASHRC
#
# Basic bashrc with slightly modified prompt, XDG Base Dir
# setup, sane history setup, colors, and few extra options
#
# by Tadeas Uhlir <tadeas.uhlir@gmail.com>

############################################################
###                     Basic Checks                     ###
############################################################
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Ensure XDG Base Directory variables are set. They are usually set in profile,
# but just to be extra careful
[[ -n "$XDG_CONFIG_HOME" ]] || export XDG_CONFIG_HOME="$HOME/.config"
[[ -n "$XDG_DATA_HOME" ]] || export XDG_DATA_HOME="$HOME/.local/share"
[[ -n "$XDG_STATE_HOME" ]] || export XDG_STATE_HOME="$HOME/.local/state"
[[ -n "$XDG_CACHE_HOME" ]] || export XDG_CACHE_HOME="$HOME/.cache"

# Ensure zsh folders exist in XDG directories
[[ -d "$XDG_STATE_HOME/bash" ]] || mkdir "$XDG_STATE_HOME/bash"

# Sourcing external files:
if [[ -r ~/.bashrc_local ]]; then
    source ~/.bashrc_local
fi

if [[ -r ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi

############################################################
###           Options and Other Configurations           ###
############################################################
# History configuration:
HISTSIZE=5000
HISTFILESIZE=10000
HISTFILE="$XDG_STATE_HOME/bash/history"
shopt -s histappend

shopt -s extglob  # Enable extended globbing
shopt -s dotglob  # Enable globbing and matching files beginning with .

# Dircolors configuration:
DIRCOLORSFILE=~/.dircolors
[[ -r "$DIRCOLORSFILE" ]] && eval "$(dircolors $DIRCOLORSFILE)"

# Prompt configuration:
# Taken straight from the example bashrc of ArchLinux
PS1='\[\033[01;33m\]\u@\h\[\033[00;37m\]=>\[\033[01;34m\]\w\[\033[00;37m\]\$\[\033[00m\] '

# On macOS, bash-completion needs to be sourced manually
if [[ "$(uname -s)" == Darwin ]]; then
    [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && \
        source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi

############################################################
###                      Functions                       ###
############################################################
lscolors() {
    IFS=:
    for ls_color in ${LS_COLORS[@]}; do # For all colors
        color=${ls_color##*=}
        ext=${ls_color%%=*}
        printf "\E[${color}m${ext}\E[0m " # echo color and extension
    done
    echo
}

color-sample() {
    for col in "$@"; do
        printf "\x1b[38;5;${col}mxxxxxxx\x1b[0m\n"
    done
}
