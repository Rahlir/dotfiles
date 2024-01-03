# Source .profile common for all shells
[[ -r ~/.profile ]] && source ~/.profile

##################################################
###     Package Manager ENV Configuration      ###
##################################################
if [[ "$(uname -s)" == Linux ]]; then
    export PKG_PREFIX=/usr
elif [[ "$(uname -s)" == Darwin && (( $+commands[brew] )) ]]; then
    eval "$(brew shellenv)"
    export PKG_PREFIX=$HOMEBREW_PREFIX
fi

##################################################
###          PATH and FPATH Variables          ###
##################################################
typeset -U path; export PATH
typeset -U fpath; export FPATH

##################################################
###            Other ENV Variables             ###
##################################################
# NPM config file
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
# w3m data directory
export W3M_DIR=$XDG_DATA_HOME/w3m
# elinks config directory
export ELINKS_CONFDIR=$XDG_CONFIG_HOME/elinks
# ipython config directory
export IPYTHONDIR=$XDG_CONFIG_HOME/ipython
# directory for virtualenvs of virtualenvwrapper 
export WORKON_HOME=$XDG_DATA_HOME/virtualenvs
# GO language data directory
export GOPATH=$XDG_DATA_HOME/go
# NBRC for nb.sh utility
export NBRC_PATH=$XDG_CONFIG_HOME/nb/nbrc
# Directory for ZK notes
export ZK_NOTEBOOK_DIR=$HOME/Documents/rahlir-notes
# MYPY cache directory
export MYPY_CACHE_DIR="$XDG_CACHE_HOME"/mypy
# Jupyter config directory
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
# Gem data and cache
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
# Rust Cargo home
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# Texlive cache
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
# SQLite history
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
# Ruby bundler
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
