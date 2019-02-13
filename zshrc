# ---------------------------Sourcing External Files-----------------------------
# Mac specific file
if [ -f ~/.bashrc_mac ]; then
    source ~/.bashrc_mac
fi

# Redirecting to machine specific settings
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# Redirecting to aliases file
if [ -f ~/.bashrc_aliases ]; then
    source  ~/.bashrc_aliases
fi

# ---------------------------Configuration Options------------------------------
#
HISTSIZE=8000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=8000               # Number of history entries to save to disk

setopt append_history
setopt share_history
setopt inc_append_history

export POWERLINE_COMMAND=powerline
powerline-daemon -q
. $POWERLINEDIR/bindings/zsh/powerline.zsh

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

export KEYTIMEOUT=1
bindkey -v

# Add colors
test -r $DIRCOLORSDIR && eval "$(dircolors $DIRCOLORSDIR)"

# Set default editor
VISUAL=vim; export VISUAL EDITOR=vim; export EDITOR

# ----------------------------------Functions------------------------------------
colors-sample() {
    for col in "$@"; do
        printf "\x1b[38;5;${col}mxxxxxxx\x1b[0m\n"
    done
}

# ---------------------------------Compinstall-----------------------------------
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' ignore-parents parent pwd directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' original false
zstyle :compinstall filename '/Users/rahlir/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
