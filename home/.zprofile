# maybe start a GUI from first tty if one isn't running
# we need to test that we're outside tmux, as environment variables are inherited when starting new tmux sessions
if [ -z "${TMUX}" -a -z "${DISPLAY}" -a "${XDG_VTNR}" -eq 1 ]; then
    if [ -f ~/.amc.start.weston ]; then
        #. ~/src/weston.env.sh
        exec weston-launch > "${HOME}/.weston.log" 2>&1
    elif [ -f ~/.amc.start.sway ]; then
        exec sway > "${HOME}/.sway.log" 2>&1
    else
        # according to man 5 xorg.conf an absolute directory should not be usable for a non root user :shrug:
        exec startx -- -configdir "${HOME}/.config/X11/xorg.conf.d" > "${HOME}/.x.log" 2>&1
    fi
fi
