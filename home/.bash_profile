[[ -f ~/.bashrc ]] && . ~/.bashrc

# start X if we are logged into the first tty, providing it's not already running
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    mv "${HOME}/.x.log" "${HOME}/.x.log.prev" > /dev/null 2>&1
    startx > "${HOME}/.x.log" 2>&1
fi
