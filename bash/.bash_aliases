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
[[ -n "$ZK_NOTEBOOK_DIR" && -d "$ZK_NOTEBOOK_DIR" ]] && alias notes='cd "$ZK_NOTEBOOK_DIR"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Shortcuts to rc files
alias vimrc='$EDITOR ~/.vimrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.lua'
alias zshrc='$EDITOR ~/.zshrc'
