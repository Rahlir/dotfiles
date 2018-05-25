#!/bin/bash

test -d ../.origdotold && rm -r ../.origdotold
test -d ../.origdot && mv -vf ../.origdot ../.origdotold
mkdir -vp ../.origdot/.config

for file in *; do
	if [ "$file" == "README.md" ] || [ "$file" == "bootstrap.sh" ]; then
		continue;
	fi

	if [ "$file" == "config" ] || [ "$file" == "vim" ]; then
		for cfile in "$file"/*; do
			if [ -a ../."$cfile" ] && ! [ -h ../."$cfile" ]; then
				mv -v ../."$cfile" ../.origdot/."$file" || exit 1
			fi
			ln -vfsn "../.dotfiles/$cfile" ../."$cfile"
		done
	else
		if [ -a ../."$file" ] && ! [ -h ../."$file" ]; then
			mv -v ../."$file" ../.origdot/ || exit 1
		fi
		ln -vfsn ".dotfiles/$file" ../."$file"
	fi
done

rmdir ../.origdot/.config ../.origdot
