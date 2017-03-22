[[ -f ~/.bashrc ]] && . ~/.bashrc

# start X on the first tty, if it's not already running
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    startx
fi
