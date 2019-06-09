#!/bin/bash

set -e

shellfilter='bashrc'
sysname=$(uname)
case "${sysname}" in
    Linux*) sysfilter='bashrc_mac';;
    Darwin*) sysfilter='bashrc_linux';;
    *) echo "Unknown system: "$sysname""
        exit 1
        ;;
esac

usage="$(basename "$0") [-htcb]

where:
    -h         show this help and exit
    -t         test mode
    -c         run test mode before bootstrapping
    -b         bootstrap for bash, default is zshell"

while getopts ':htcb' option; do
	case "$option" in
		h) 	echo "$usage"
				exit
				;;
		t)  testmode=true
			  ;;
		c)  shift
				$0 -t
				read -p "Continue? [Y(es)/N(o)] " -n 1 -r
				echo 
				if [[ $REPLY =~ ^[Yy]$ ]]; then
					test -d ~/.origdotold && rm -r ~/.origdotold
					test -d ~/.origdot && mv -vf ~/.origdot ~/.origdotold
					mkdir -vp ~/.origdot/
					$0
				fi 
				exit 0
				;;
        b)  shellfilter='zshrc'
            ;;
		\?) printf "illegal option: -%s\n" "$OPTARG" >&2
			  echo "$usage" >&2
				exit 1
				;;
	esac
done
shift $((OPTIND-1))

cmd() {
	if [ "$testmode" = true ]; then
		if [ "$1" == "rm" ]; then
			echo "To Remove: "${@:3}""
		elif [ "$1" == "rmdir" ]; then
			echo "To Remove: "${@:2}""
		elif [ "$1" == "mv" ]; then
			echo ""$3" > "$4""
		elif [ "$1" == "ln" ]; then
			echo "Symlink: "$3" > "$4""
		fi
	else
		"${@}"
	fi
}


filelist=$(find . -maxdepth 1 -mindepth 1 | grep -Ev '(\.bootignore|\.git)' | grep -v -f <(sed 's/\([.|]\)/\\\1/g; s/\?/./g ; s/\*/.*/g' .bootignore) | grep -v "$sysfilter" | grep -v "$shellfilter")

for file in $filelist; do
	filename=$(basename "$file")
	filepath=$(realpath "$file")

	if [ -d $filename ] && [ -d ~/.$filename ] && ! [ -L ~/.$filename ]; then
		for cfile in $filename/*; do
			cfilename=$(basename "$cfile")
			cfilereal=$(realpath $cfile)

			if [ -a ~/."$cfile" ] && ! [ -L ~/."$cfile" ]; then
				cmd mv -v ~/."$cfile" ~/.origdot/
			fi
			cmd ln -vfsn "$cfilereal" ~/."$filename"/"$cfilename"
		done
	else
		if [ -a ~/."$filename" ] && ! [ -L ~/."$filename" ]; then
			cmd mv -v ~/."$file" ~/.origdot/
		fi
		cmd ln -vfsn "$filepath" ~/."$filename"
	fi
done

cmd rmdir ../.origdot/.config ../.origdot
