# start a GUI from first tty, providing one's not already running
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    if [ -f ~/.useweston ]; then
        exec weston > "${HOME}/.weston.log" 2>&1
    elif [ -f ~/.usesway ]; then
        exec sway > "${HOME}/.sway.log" 2>&1
    else 
        exec startx > "${HOME}/.startx.log" 2>&1
    fi
fi
