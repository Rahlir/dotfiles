# Source .profile common for all shells
[[ -r ~/.profile ]] && source ~/.profile

##################################################
###     Package Manager ENV Configuration      ###
##################################################
if [[ "$(uname -s)" == Linux ]]; then
    export PKG_PREFIX=/usr
elif [[ "$(uname -s)" == Darwin && (( $+commands[brew] )) ]]; then
    eval "$(brew shellenv)"
    export PKG_PREFIX=$BREW_PREFIX
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
