# start a display of some sort if we are logging directly into the first tty, providing it's not already running
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    if [ -f ~/.useweston ]; then
        mv "${HOME}/.weston.log" "${HOME}/.weston.log.old" > /dev/null 2>&1
        weston > "${HOME}/.weston.log" 2>&1
    elif [ -f ~/.usesway ]; then
        mv "${HOME}/.sway.log" "${HOME}/.sway.log.old" > /dev/null 2>&1
        sway > "${HOME}/.sway.log" 2>&1
    else 
        mv "${HOME}/.X.log" "${HOME}/.X.log.old" > /dev/null 2>&1
        startx > "${HOME}/.X.log" 2>&1
    fi
fi
