# ---------------------------Sourcing External Files-----------------------------
# Needs to happen as mac overrides path in profile (don't ask mne why...)
if [ -f ~/.zshenv ]; then
    source ~/.zshenv
fi

# Mac specific file
if [ -f ~/.bashrc_mac ]; then
    source ~/.bashrc_mac
fi

if [ -f ~/.bashrc_linux ]; then
    source ~/.bashrc_linux
fi

# Redirecting to aliases file
if [ -f ~/.sh_aliases ]; then
    source  ~/.sh_aliases
fi


# ---------------------------Configuration Options------------------------------
HISTSIZE=8000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=8000               # Number of history entries to save to disk

setopt append_history
setopt share_history
setopt inc_append_history


# -------------------------Loading Zshcontrib Widgets---------------------------
autoload -U edit-command-line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N clear-screen

bindkey -v
export KEYTIMEOUT=1
bindkey -M vicmd '^v' edit-command-line
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

bindkey "^e" clear-screen

# Up/down key search in history
# Uncomment the correct OS
# -----------------------------------MACOS--------------------------------------
# bindkey "^[[A" up-line-or-beginning-search # Up
# bindkey "^[[B" down-line-or-beginning-search # Down
# -----------------------------------LINUX--------------------------------------
# bindkey "^[OA" up-line-or-beginning-search # Up
# bindkey "^[OB" down-line-or-beginning-search # Down


# Add colors
test -r $DIRCOLORSDIR && eval "$(dircolors $DIRCOLORSDIR)"

# ------------------------------Powerline setup---------------------------------
export POWERLINE_COMMAND=powerline
powerline-daemon -q
. $POWERLINEDIR/bindings/zsh/powerline.zsh

# ----------------------------------Functions------------------------------------
function precmd() {
    echo -ne "\033]0;zsh\007"
}

function colors-sample() {
    for col in "$@"; do
        printf "\x1b[38;5;${col}mxxxxxxx\x1b[0m\n"
    done
}

function rsync-short() {
    rsync -ahv --partial --progress --timeout=5 "$@"
}

function start-barrier() {
    /Applications/Barrier.app/Contents/MacOS/barrierc --name Laptop wall-e.karlov.mff.cuni.cz:1352
}

function end-barrier() {
    while pgrep -q barrierc; do
        killall barrierc
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

# ------------------------Environment Variables Setup---------------------------
# My python modules 
export PYTHONPATH="$HOME/Development/Libraries/python-tools:$HOME/Development/Libraries/rahlir_vibrations"
#
# Redirecting to machine specific settings
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# -----------------------------------Conda--------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/rahlir/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/rahlir/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/rahlir/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/rahlir/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
