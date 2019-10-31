typeset -U path
typeset -U fpath

# -----------------------------------editor-------------------------------------
# Set default editor
VISUAL=nvim; export VISUAL
EDITOR=nvim; export EDITOR

# -----------------------------------fpath--------------------------------------
# Add to fpath variable
fpath=($fpath $HOME/.zsh_completions)

# -----------------------------------Other--------------------------------------
DIRCOLORSDIR="$HOME/.dircolors/dircolors.base16"
export POWERLINEDIR="$HOME/anaconda3/lib/python3.6/site-packages/powerline"

# docbrown specific
export TERMINFO="/usr/local/opt/ncurses/share/terminfo"
export LDFLAGS="-L/usr/local/opt/ncurses/lib -L/usr/local/opt/llvm/lib -Wl"
export CPPFLAGS="-I/usr/local/opt/ncurses/include -I/usr/local/opt/llvm/include -I/usr/local/include"
export PKG_CONFIG_PATH="/usr/local/opt/ncurses/lib/pkgconfig"
