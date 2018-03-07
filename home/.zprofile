# maybe start a GUI from first tty if one isn't running
# we need to test for tmux as it starts a login shell
if [ -z "${TMUX}" -a -z "${DISPLAY}" -a "${XDG_VTNR}" -eq 1 ]; then
    if [ -f ~/.amc.start.weston ]; then
        exec weston > "${HOME}/.weston.log" 2>&1
    elif [ -f ~/.amc.start.sway ]; then
        exec sway > "${HOME}/.sway.log" 2>&1
    elif [ -f ~/.amc.start.x ]; then
        exec startx > "${HOME}/.x.log" 2>&1
    fi
fi