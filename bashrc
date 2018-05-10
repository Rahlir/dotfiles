if [ -f ~/.bashrc_mac ]; then
	source ~/.bashrc_mac
elif [ -f ~/.bashrc_linux ]; then
	source ~/.bashrc_linux
fi

# Redirecting to aliases file
if [ -f ~/.bashrc_aliases ]; then
	source  ~/.bashrc_aliases
fi

# Add all autocompletions if any are installed
if [ -d $COMPLETIONDIR ]; then
	for F in "$COMPLETIONDIR"/*; do
		if [ -f "${F}" ]; then
			source "${F}";
		fi
	done
fi

# Add colors
test -r $DIRCOLORSDIR && eval "$(dircolors $DIRCOLORSDIR)" # && echo "Dircolors Loaded"

# Powerline
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi
export POWERLINE_COMMAND=powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $POWERLINEDIR/bindings/bash/powerline.sh


BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# My python modules 
export PYTHONPATH="$PYTHONPATH:$HOME/Development/python-tools"


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
