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

# die caps lock
setxkbmap -option ctrl:nocaps

# empty background
isAThing xsetroot && xsetroot -solid gray20 -cursor_name left_ptr

# setup displays
isAThing xlayoutdisplay && xlayoutdisplay

# monitor sensors
isAThing sensorsmonitor && sensorsmonitor&

# (re)start redshift
systemctl --user restart redshift 2>/dev/null &

# slock the screen after 5 mins
isAThing xautolock && isAThing slock && xautolock -locker slock -time 5 &

# start up nm-applet, for use by networkmanager_dmenu
# it won't be shown without a tray however is necessary to spawn windows
isAThing nm-applet && nm-applet > /dev/null 2>&1 &

# clear any xmonad saved state
rm -f .xmonad/xmonad.state

# start xmonad
xmonad &

# wait for xmonad to stop
wait $!
