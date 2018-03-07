# start a GUI from first tty, providing one's not already running
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    if [ -f ~/.amc.start.weston ]; then
        exec weston > "${HOME}/.weston.log" 2>&1
    elif [ -f ~/.amc.start.sway ]; then
        exec sway > "${HOME}/.sway.log" 2>&1
    elif [ -f ~/.amc.start.x ]; then
        exec startx > "${HOME}/.x.log" 2>&1
    fi
fi
