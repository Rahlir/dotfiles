#!/bin/bash

for file in *; do
	if [ "$file" == "README.md" ]; then
		continue;
	fi
	if [ -f ../."$file" ]; then
		if ! [ -d ../.origdot ]; then
			mkdir ../.origdot/
		fi
		mv ../."$file" ../.origdot/
	fi

	ln -vfs ".dotfiles/$file" ../."$file"
done


