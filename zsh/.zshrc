# ZSHRC
#
# Configuration for heavily customized zsh environment. This config
# generally makes no assumptions. It doesn't modify $PATH variable - that
# is done by the corresponding zprofile file. It also doesn't
# define any functions - that should be done in functions.zsh file.
# Some general references:
# - https://wiki.archlinux.org/title/zsh
#
# by Tadeas Uhlir <tadeas.uhlir@gmail.com>

################################################################################
#####                             Basic Checks                             #####
################################################################################
# Ensure XDG Base Directory variables are set. They are usually set in profile,
# but just to be extra careful
[[ -n $XDG_CONFIG_HOME ]] || export XDG_CONFIG_HOME=$HOME/.config
[[ -n $XDG_DATA_HOME ]] || export XDG_DATA_HOME=$HOME/.local/share
[[ -n $XDG_STATE_HOME ]] || export XDG_STATE_HOME=$HOME/.local/state
[[ -n $XDG_CACHE_HOME ]] || export XDG_CACHE_HOME=$HOME/.cache

# Ensure zsh folders exist in XDG directories
[[ -d $XDG_STATE_HOME/zsh ]] || mkdir $XDG_STATE_HOME/zsh
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir $XDG_CACHE_HOME/zsh

################################################################################
#####                       Sourcing External Files                        #####
################################################################################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc
if [[ -r $XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh ]]; then
  source $XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh
fi

# Source machine specific configuration
if [[ -r ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi

# Load aliases
if [[ -r ~/.bash_aliases ]]; then
    source ~/.bash_aliases  # Aliases for both bash and zsh
fi
if [[ -r $XDG_CONFIG_HOME/zsh/aliases.zsh ]]; then
    source  $XDG_CONFIG_HOME/zsh/aliases.zsh  # Zsh specific aliases
fi

# Load custom zsh functions
if [[ -r $XDG_DATA_HOME/zsh/functions.zsh ]]; then
    source $XDG_DATA_HOME/zsh/functions.zsh
fi

# Load useful autoloadable zsh functions
autoload -Uz zmv

################################################################################
#####                            Basic Options                             #####
################################################################################
# History configuration:
HISTSIZE=15000  # How many lines of history to keep in memory
# For me it makes sense to have larger history file than history in memory,
# since the use would be to look up something I used a while back, hence no
# need to keep it in memory, grep is enough
SAVEHIST=30000
HISTFILE=$XDG_STATE_HOME/zsh/history
setopt extended_history
setopt share_history  # Share history between active session
setopt hist_ignore_dups

# Dirstack configuration:
DIRSTACKSIZE=15  # How many directories to keep in dirstack
setopt auto_pushd pushd_silent pushd_to_home pushd_ignore_dups pushd_minus

# Other options:
setopt extended_glob  # Enable extended globbing
setopt globdots  # Enable globbing and matching files beginning with .

# Dircolors configuration:
DIRCOLORSFILE=$HOME/.dircolors
[[ -r $DIRCOLORSFILE ]] && eval "$(dircolors $DIRCOLORSFILE)"

################################################################################
#####                             Custom Hooks                             #####
################################################################################
autoload -Uz add-zsh-hook

# Hooks to live update of environment of shells inside TMUX
_update_tmux_env() {
    eval $(tmux show-environment -s)
}
_update_powerlevel9k_themebg() {
    if [[ ${THEMEBG:-dark} != $POWERLEVEL9K_THEMEBG && -r $XDG_CONFIG_HOME/zsh/p10k.zsh ]]; then
        source $XDG_CONFIG_HOME/zsh/p10k.zsh
    fi
}
if [[ -n "$TMUX" ]]; then
    add-zsh-hook -Uz preexec _update_tmux_env
    add-zsh-hook -Uz preexec _update_powerlevel9k_themebg
fi

# Precmd hook to set window title
function precmd() {
    echo -ne "\033]0;zsh\007"
}

# Precmd hook to update completion on installing new package with pacman
if (( $+commands[pacman] )) && [[ -f /etc/pacman.d/hooks/zsh.hook ]]; then
    zshcache_time="$(date +%s%N)"
    _rehash_precmd() {
        if [[ -a /var/cache/zsh/pacman ]]; then
            local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
            if (( zshcache_time < paccache_time )); then
                rehash
                compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
                zshcache_time="$paccache_time"
            fi
        fi
    }

    add-zsh-hook -Uz precmd _rehash_precmd
fi

################################################################################
#####                          ZLE Configuration                           #####
################################################################################
autoload -Uz edit-command-line up-line-or-beginning-search down-line-or-beginning-search
zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
autoload -Uz select-quoted select-bracketed
zle -N select-quoted
zle -N select-bracketed

# Setting vi mode and binding keys:
bindkey -v
export KEYTIMEOUT=1  # Entering cmd mode quickly
# Insert mode bindings
bindkey '^n' edit-command-line
bindkey "^e" clear-screen
bindkey "^[[1;5C" vi-forward-blank-word
bindkey "^[[1;5D" vi-backward-blank-word
bindkey "^u" kill-whole-line  # Without this ^u only removes new text since insert mode
# Cmd mode bindings
bindkey -M vicmd '^e' clear-screen
bindkey -M vicmd '^n' edit-command-line
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
# Surround and inner quotes/bracket functionality
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround
for km in viopp visual; do
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km -- $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km -- $c select-bracketed
  done
done

typeset -g -A key
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
[[ -n "${key[Up]}" ]] && bindkey -- "${key[Up]}" up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# ZSH removes space when adding pipe symbol after completion. Annoying behavior
# which can be fixed by removing pipe symbol from ZLE_REMOVE_SUFFIX_CHARS variable
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

################################################################################
#####                       Completion Configuration                       #####
################################################################################
# Inspiration:
# - https://github.com/mattjj/my-oh-my-zsh/blob/master/completion.zsh
# - https://www.codyhiar.com/blog/zsh-autocomplete-with-ssh-config-file/
# - https://github.com/dotphiles/dotzsh/blob/master/modules/completion/init.zsh

# Adding custom completion functions if they exist
[[ -d $XDG_DATA_HOME/zsh/site-functions ]] && \
    fpath+=$XDG_DATA_HOME/zsh/site-functions

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache-$ZSH_VERSION"
# When an exact dir is typed, do not perform completion on it, otherwise we get
# annoying behavior when trying to complete something like 'dir/file.txt' where
# dir is corrected when file.txt is not there -> clashes with ignore-parents
# zstyle ':completion:*:paths' accept-exact "^(..)"
# Ignore parent dir when doing things like cd ../different_folder
zstyle ':completion:*' ignore-parents parent pwd
# Matcher list that allows additional case insensitive completion, adding strings
# to the left of anchor
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
    'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
# This is style for approximate completer: without it, menu is launched immediately,
# making it different from other completers. This causes the completer to start
# with correcting the string first. Unfortunately setting it specifically for
# approximate completer doesn't work
zstyle ':completion:*' insert-unambiguous true
# Turn the above option for match completer since that would not work with 'match-original'
# option
zstyle ':completion:*:match:*' insert-unambiguous false
# Do not allow appending arbitrary string at cursor's position. Since we want to be
# specific when using match completer and add wildcards by ourselves
zstyle ':completion:*:match:*' match-original only
# Errors for approximate completer: allow 0 errors when string has below 3 characters or 1
# error for longer strings
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)<4?0:1)))'
# Ignore zsh functions with special meaning (such as completion functions starting with '_')
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
# For rm, kill, and diff, do not offer already selected files / processes as possible
# completions
zstyle ':completion:*:(rm|kill|diff|rmdir):*' ignore-line other
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'
# Without the following the hostname completion is not populated from ssh config unless
# no matches are found in known_hosts file. This unreadable piece of code was copied
# over from https://github.com/dotphiles/dotzsh/blob/master/modules/completion/init.zsh
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'
# Visual style configuration:
zstyle ':completion:*' menu select
# Use LS_COLORS to style filename completion, bold aqua background for selected item in menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" "ma=01;30;46"
# Use complist for listing completions when they do not fit on the screen, show
# message with info regarding position in the list
zstyle ':completion:*:default' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
# Display messages (have not seen shown yet)
zstyle ':completion:*:messages' format '%d'
# Aqua underlined title for groups
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'
# Red bold "no matches found" message
zstyle ':completion:*:warnings' format "%B%F{red}-- no matches found --%b%f"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:-command-:*' group-order aliases builtins functions commands

# complist module configuration:
zmodload zsh/complist
# Enter selects an item in the menu and executes the command
bindkey -M menuselect '^M' .accept-search
# Escape selects an item in the menu and enter vicmd mode
bindkey -M menuselect '^[' .accept-line
# Space accepts item and doesn't execute the command
bindkey -M menuselect ' ' .accept-search
# Ctrl space accepts item and starts menu selection on next word
bindkey -M menuselect '^@' accept-and-infer-next-history
# Undoes the selection made with space
bindkey -M menuselect '^u' undo
# Escape quits listing in listscroll mode
bindkey -M listscroll '^[' .accept-search
# q ends listing mode
bindkey -M listscroll 'q' send-break

# Loading completion and bash completion:
autoload -Uz compinit bashcompinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
bashcompinit

for bashcompl_f in $XDG_DATA_HOME/bash/bash_completion.d/*(N); do
    . $bashcompl_f
done

# For pipx completion, you need to register the completion
if (( $+commands[pipx] )) && [[ $PKG_PREFIX != ${HOMEBREW_PREFIX:-none} ]]; then
    eval "$(register-python-argcomplete pipx)"
fi

################################################################################
#####                       Utilities Configuration                        #####
################################################################################
# command_not_found_handler:
[[ -r $XDG_CONFIG_HOME/zsh/command_not_found.zsh ]] && \
    source $XDG_CONFIG_HOME/zsh/command_not_found.zsh

# zsh-syntax-highlighting:
_synhl_paths=(
    $SYNHL_PATH(-.N)
    $PKG_PREFIX/share/(zsh/)#(plugins/)#zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(-.N)
)
(( $#_synhl_paths )) && [[ -r $_synhl_paths[1] ]] && source $_synhl_paths[1]

# Pyenv:
if (( $+commands[pyenv] )); then
    eval "$(pyenv init -)"
fi
# Virtualenvwrapper script:
_virtualenvwrapper_path=${VIRTUALENVWRAPPER_PATH:-$PKG_PREFIX/bin/virtualenvwrapper_lazy.sh}
[[ -r $_virtualenvwrapper_path ]] && source $_virtualenvwrapper_path

# Other:
# Some SSL library functions might still use RANDFILE, see openssl-req(1ssl)
export RANDFILE=$XDG_STATE_HOME/rnd
# Neo(mutt) requires tty for GPG passphrase input
if (( $+commands[neomutt] )) || (( $+commands[mutt] )); then
    export GPG_TTY=$TTY
fi

# Powerlevel10k:
_p10k_paths=(
    $P10K_PATH/powerlevel10k.zsh-theme(-.N)
    $PKG_PREFIX/(share|opt)/(zsh-theme-powerlevel10k|powerlevel10k)/powerlevel10k.zsh-theme(-.N)
)
(( #_p10k_paths )) && [[ -r $_p10k_paths[1] ]] && source $_p10k_paths[1]
# Load configuration
[[ -r $XDG_CONFIG_HOME/zsh/p10k.zsh ]] && \
    source $XDG_CONFIG_HOME/zsh/p10k.zsh

# Unset local variables
unset _synhl_paths
unset _p10k_paths
unset _virtualenvwrapper_path
