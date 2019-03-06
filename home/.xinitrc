# shell agnostic function returns true if ${1} is a valid executable, function etc.
function isAThing() {
    return $(type "${1}" > /dev/null 2>&1)
}

# run all system xinitrc shell scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$script" -a ! -d "$script" ] && . "$script"
    done
fi

# merge .Xresources, in case we're running without any sort of display manager
if [ -r ${HOME}/.Xresources ]; then
    xrdb -load ${HOME}/.Xresources
fi

# start all the background apps
dex -a

# setup displays
isAThing xlayoutdisplay && xlayoutdisplay

# (re)start redshift
systemctl --user restart redshift 2>/dev/null &

# slock the screen after 5 mins
isAThing xautolock && isAThing slock && xautolock -locker slock -time 5 &

# start dwm
slstatus &
dwm &

# wait for dwm to stop
wait $!
