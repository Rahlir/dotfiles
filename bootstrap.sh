#!/bin/bash

set -e

usage="$(basename "$0") [-ht] 

where:
	-h         show this help and exit
	-t         test mode"

while getopts ':htc' option; do
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
		# echo "RUN1: "$1""
		# echo "RUN2: "$2""
		# echo "RUN3: "$3""
		# echo "RUN4: "$4""
	else
		"${@}"
	fi
}


filelist=$(find . -depth 1 | grep -Ev '(\.bootignore|\.git)' | grep -v -f <(sed 's/\([.|]\)/\\\1/g; s/\?/./g ; s/\*/.*/g' .bootignore))

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
