typeset -U path
typeset -U fpath

# -----------------------------------editor-------------------------------------
# Set default editor
VISUAL=nvim; export VISUAL
EDITOR=nvim; export EDITOR

# --------------------------------c/c++ flags-----------------------------------
export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/llvm/include -I/usr/local/include $CPPFLAGS"

# -----------------------------------fpath--------------------------------------
# Add to fpath variable
fpath=($fpath $HOME/.zsh_completions)

# ------------------------------------path--------------------------------------
if [ -d "$HOME/.local/bin" ]; then
    path=(~/.local/bin $path)
fi

export PATH

# -----------------------------------Other--------------------------------------
DIRCOLORSDIR=$HOME/.dircolors/dircolors.base16
