[[ -f ~/.bashrc ]] && . ~/.bashrc

# start X if we are logged into the first tty, providing it's not already running
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    mv "${HOME}/.X.log" "${HOME}/.X.log.old" > /dev/null 2>&1
    startx > "${HOME}/.X.log" 2>&1
fi
