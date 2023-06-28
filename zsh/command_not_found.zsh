if (( ! $+functions[command_not_found_handler] )); then
    if (( $+commands[pacman] )); then
        function command_not_found_handler() {
            local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
            printf 'zsh: command not found: %s\n' "$1"
            local entries=(
                ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
            )
            if (( ${#entries[@]} ))
            then
                printf "${bright}$1${reset} may be found in the following packages:\n"
                local pkg
                for entry in "${entries[@]}"
                do
                    # (repo package version file)
                    local fields=(
                        ${(0)entry}
                    )
                    if [[ "$pkg" != "${fields[2]}" ]]
                    then
                        printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
                    fi
                    printf '    /%s\n' "${fields[4]}"
                    pkg="${fields[2]}"
                done
            fi
            return 127
        }

    elif (( $+commands[brew] )); then
        command_not_found_handler() {

            local cmd="$1"

            # The code below is based off this Linux Journal article:
            #   http://www.linuxjournal.com/content/bash-command-not-found

            # do not run when inside Midnight Commander or within a Pipe, except if CI
            if [[ -z "$CONTINUOUS_INTEGRATION" && -n "$MC_SID" || ! -t 1 ]] ; then
                # Zsh versions 5.3 and above don't print this for us.
                [[ -n "$ZSH_VERSION" && "$ZSH_VERSION" > "5.2" ]] && \
                    echo "zsh: command not found: $cmd" >&2
                return 127
            fi

            if [[ "$cmd" != "-h" && "$cmd" != "--help" && "$cmd" != "--usage" && "$cmd" != "-?" ]]; then
                local txt="$(brew which-formula --explain $cmd 2>/dev/null)"
            fi

            if [[ -z "$txt" ]]; then
                # Zsh versions 5.3 and above don't print this for us.
                [[ -n "$ZSH_VERSION" && "$ZSH_VERSION" > "5.2" ]] && \
                    echo "zsh: command not found: $cmd" >&2
            else
                echo "$txt"
            fi

            return 127
        }
    elif [[ -x /usr/lib/command-not-found ]]; then
        function command_not_found_handler() {
            [[ -x /usr/lib/command-not-found ]] || return 1
            /usr/lib/command-not-found -- ${1+"$1"} && :
        }
    fi
fi
