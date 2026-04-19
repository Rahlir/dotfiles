#!/usr/bin/env zsh

if ! (( $+commands[brew] )); then
    echo -n "error"
    exit 1
fi

cache=/tmp/brew-status
lock=/tmp/brew-status.lock

REFRESH_PERIOD=60  # seconds between brew outdated runs

# If the cache is fresh enough, return it immediately without scheduling a
# refresh. stat syntax differs between GNU stat and BSD stat — probe the binary
# directly rather than inferring from the OS, since macOS may have GNU coreutils
# installed.
if [[ -f "$cache" ]]; then
    if stat --version &>/dev/null; then
        # GNU stat (Linux, or macOS with coreutils)
        cache_mtime=$(stat -c %Y "$cache")
    else
        # BSD stat (macOS without coreutils)
        cache_mtime=$(stat -f %m "$cache")
    fi
    cache_age=$(( $(date +%s) - cache_mtime ))
    if (( cache_age < REFRESH_PERIOD )); then
        cat "$cache"
        exit 0
    fi
fi

# Spawn a background refresh only if no job is currently running.
# The lock file stores the PID of the background job; if that process is no
# longer alive the lock is stale (e.g. after a crash) and we are safe to
# start a new one.
if [[ ! -f "$lock" ]] || ! kill -0 "$(cat "$lock")" 2>/dev/null; then
    # Run brew in the background so this script returns immediately.
    # Write to a temp file first, then atomically rename it to the cache file
    # to avoid the main process reading a partially-written result.
    {
        brew outdated -q 2>/dev/null | wc -l | tr -d ' ' > "${cache}.tmp" \
            && mv "${cache}.tmp" "$cache"
        rm -f "$lock"
    } &
    # Store the background job's PID so we can check liveness on the next run.
    echo $! > "$lock"
fi

# Return the cached result immediately, or a placeholder on the very first run
# before the cache has been populated.
if [[ -f "$cache" ]]; then
    cat "$cache"
else
    echo -n "..."
fi
