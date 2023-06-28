# Enable color output
if command -v dircolors &> /dev/null; then
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# Basic aliases
alias q='exit'
alias c='clear'
alias cc='clear && tmux clear-history'
alias ll='LC_COLLATE=C ls -alF'
alias lsa='ls -a'
alias pfind='find . -name'

# CD aliases
[[ -d ~/Development ]] && alias dev='cd ~/Development'
[[ -d ~/Documents ]] && alias doc='cd ~/Documents'
[[ -d ~/Software ]] && alias soft='cd ~/Software'
[[ -d "$DOTDIR" ]] && alias dot='cd "$DOTDIR"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git aliases
alias gcom='git commit'
alias gst='git status'
alias gmod='git add -u'
alias gac='git add -u && git commit'

# Shortcuts to rc files
alias vimrc='$EDITOR ~/.vimrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.lua'
alias zshrc='$EDITOR ~/.zshrc'
