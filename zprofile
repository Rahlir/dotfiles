
# ------------------------------------path--------------------------------------
# docbrown specific path
if [ -d "/usr/local/opt/lammps/bin" ]; then
    path=("/usr/local/opt/lammps/bin" $path)
fi
if [ -d "/usr/local/opt/ruby/bin" ]; then
    path=("/usr/local/opt/ruby/bin" $path)
fi
if [ -d "/usr/local/lib/ruby/gems/2.6.0/bin" ]; then
    path=("/usr/local/lib/ruby/gems/2.6.0/bin" $path)
fi
if [ -d "/usr/local/opt/ncurses/bin" ]; then
    path=("/usr/local/opt/ncurses/bin" $path)
fi

if [ -d "$HOME/.local/bin" ]; then
    path=("$HOME/.local/bin" $path)
fi
if [ -d "$HOME/anaconda3/bin" ]; then
    path=("$HOME/anaconda3/bin" $path)
fi

export PATH
