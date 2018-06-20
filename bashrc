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

# Setting history length
HISTSIZE=1000
HISTFILESIZE=2000

# Add colors
test -r $DIRCOLORSDIR && eval "$(dircolors $DIRCOLORSDIR)" # && echo "Dircolors Loaded"

# Set default editor
VISUAL=vim; export VISUAL EDITOR=vim; export EDITOR

# Set colors for less. Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less .
# export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
# export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
# export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
# export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
# export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
# export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
# export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Powerline
if [ -d "$HOME/.local/bin" ] && ! [[ :$PATH: == *:"$HOME/.local/bin":* ]]; then
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

catlines() {
	sed -n $1,$2p "$3"
}
