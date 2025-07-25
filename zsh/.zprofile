# Source .profile common for all shells
[[ -r ~/.profile ]] && source ~/.profile

##################################################
###          PATH and FPATH Variables          ###
##################################################
if [[ "$(uname -s)" == Darwin && -n $HOMEBREW_PREFIX ]]; then
    # Homebrew stores zsh completions here, which is not
    # in fpath by default.
    fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
    # there are also additional completions in zsh-completions
    if [[ -r $HOMEBREW_PREFIX/share/zsh-completions ]]; then
        fpath+=$HOMEBREW_PREFIX/share/zsh-completions
    fi
fi

typeset -U path; export PATH
typeset -U fpath; export FPATH

##################################################
###            Other ENV Variables             ###
##################################################

# If an application is installed, check that the
# parent directory for its state file exists. If
# not, create it
#
# * $1: Binary name of the application
# * $2: Variable specifying location of a state file
function _check_parent() {
    if (( # != 2 )); then
        print -P "%B%F{RED}ERROR:%b Need to specify two args for _check_parent%f"
        return 1
    fi
    local app=$1
    local statefile=$2
    if (( $+commands[$app] )); then
        [[ -d ${statefile:h} ]] || mkdir -p ${statefile:h}
    fi
}

# Docker config home
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
# Postgresrc file
export PSQLRC=$XDG_CONFIG_HOME/psqlrc
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
# Without this, virtualenvwrapper and pyenv together on arch
# throw error
if [[ "$(uname -s)" == Linux ]]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
fi
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
export SQLITE_HISTORY=$XDG_STATE_HOME/sqlite/history
_check_parent sqlite3 $SQLITE_HISTORY
# Ruby bundler
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
# TLDR C client cache, the variable is setup wrong, since it
# creates _another_ .tldrc directory within TLDR_CACHE_DIR, hence
# it needs to be set to XDG_CACHE_HOME
export TLDR_CACHE_DIR=$XDG_CACHE_HOME
# pyenv variables
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH=$PYENV_ROOT/bin:$PATH
# Kube config for kubectl
export KUBECONFIG=$XDG_CONFIG_HOME/kube/config
export KUBECACHEDIR=$XDG_CACHE_HOME/kube
if [[ "$(uname -s)" == Darwin ]]; then
    # Use keychain with pip
    export PIP_USE_FEATURE=truststore
    # Use keychain with UV
    export UV_NATIVE_TLS=1
fi
# Alternative location for USQL history
export USQL_HISTORY=$XDG_STATE_HOME/usql/history
_check_parent usql $USQL_HISTORY
export REDISCLI_HISTFILE=$XDG_DATA_HOME/redis/rediscli_history

# Unload local function
unset _check_parent
