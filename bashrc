# Define PATH
# Added by Anaconda3 5.0.0 installer
export PATH="/anaconda3/bin:$PATH"
# Setting PATH for Python 3.6
export PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:$PATH"
# Lammps directory
export PATH="/usr/local/Cellar/lammps/2017-08-11_3/bin:$PATH"

# Define CLASSPATH for Java
export CLASSPATH="/Users/rahlir/Development/Java/Jars/mysql-connector-java-5.1.44-bin.jar:$CLASSPATH"

# Redirecting to aliases file
if [ -f ~/.bashrc_aliases ]; then
	source  ~/.bashrc_aliases
fi

# Add colors
d=/Users/rahlir/.dircolors/dircolors.base16
test -r $d && eval "$(gdircolors $d)"
alias ls='gls --color'

# Powerline
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi
export POWERLINE_COMMAND=powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /anaconda3/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh

# Add all autocompletions if any are installed
if [ -d /usr/local/etc/bash_completion.d ]; then
	for F in "/usr/local/etc/bash_completion.d/"*; do
		if [ -f "${F}" ]; then
			source "${F}";
		fi
	done
fi

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

#---Functions---
things() {
	open "things:///add?title=$1"
}

colortestfc() {
	IFS=:
	for ls_color in ${LS_COLORS[@]}; do # For all colors
		color=${ls_color##*=}
		ext=${ls_color%%=*}
		printf "\E[${color}m${ext}\E[0m " # echo color and extension
	done
	echo
}
alias colortest='(colortestfc)'

tmux-colortest() {
	for i in {0..255}; do
		printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
	done
}
