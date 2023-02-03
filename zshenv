typeset -U path
typeset -U fpath

# ------------------------------------path--------------------------------------
if [ -d "$HOME/.local/bin" ]; then
    path=("$HOME/.local/bin" $path)
fi

if [ -d "$HOME/anaconda3/bin" ]; then
    path=("$HOME/anaconda3/bin" $path)
fi

export PATH

# -----------------------------------editor-------------------------------------
# Set default editor
VISUAL=nvim; export VISUAL
EDITOR=nvim; export EDITOR

# -----------------------------------fpath--------------------------------------
# Add to fpath variable
fpath=($fpath $HOME/.zsh_completions)

# -------------------------------python modules---------------------------------
export PYTHONPATH="$HOME/Development/Libraries/python-tools:$HOME/Development/Libraries/rahlir_vibrations"

# -----------------------------------Other--------------------------------------
export DIRCOLORSDIR="$HOME/.dircolors/dircolors.base16"
export POWERLINEDIR="$HOME/anaconda3/lib/python3.6/site-packages/powerline"

# docbrown specific (is this still needed?)
export TERMINFO="/usr/local/opt/ncurses/share/terminfo"
export PKG_CONFIG_PATH="/usr/local/opt/ncurses/lib/pkgconfig"
