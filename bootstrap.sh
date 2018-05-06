#!/bin/bash

test -d ../.origdot && mv -vf ../.origdot ../.origdotold
mkdir -vp ../.origdot/.config

for file in *; do
	echo $file
	if [ "$file" == "README.md" ]; then
		continue;
	fi

	if [ "$file" == "config" ]; then
		for cfile in "$file"/*; do
			if [ -a ../."$file" ] && ! [ -h ../."$file" ]; then
				mv -v ../."$cfile" ../.origdot/."$file" || exit 1
			fi
			ln -vfs "../.dotfiles/$cfile" ../."$cfile"
		done
	else
		if [ -a ../."$file" ] && ! [ -h ../."$file" ]; then
			mv -v ../."$file" ../.origdot/ || exit 1
		fi
		ln -vfs ".dotfiles/$file" ../."$file"
	fi
done
