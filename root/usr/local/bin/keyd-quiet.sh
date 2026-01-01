#!/usr/bin/env sh

echo "${0}"
echo "KEYD_DEBUG=${KEYD_DEBUG}"

# ignore unsupported evdev code from game controllers etc.
exec keyd | grep --line-buffered -v "unsupported evdev code"
