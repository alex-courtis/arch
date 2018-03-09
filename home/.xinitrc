# .xsession

function isAThing() {
    return $(type "${1}" > /dev/null 2>&1)
}

# run all system xinitrc shell scripts - xdm doesn't automagically do this
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$script" -a ! -d "$script" ] && . "$script"
    done
fi

# apply nvidia settings if available
isAThing nvidia-settings && nvidia-settings --load-config-only

# setup displays
isAThing xLayoutDisplay && xLayoutDisplay

# cool legacy background
isAThing xsetroot && xsetroot -grey

# slock the screen after 5 mins
isAThing xautolock && isAThing slock && xautolock -locker slock -time 5 &

# start touchpad gesture recogniser
isAThing libinput-gestures && libinput-gestures &

# clear any xmonad saved state
rm -f .xmonad/xmonad.state

# start up nm-applet, for use by networkmanager_dmenu
# it won't be shown without a tray however is necessary to spawn windows
isAThing nm-applet && nm-applet > /dev/null 2>&1 &

# start xmonad
xmonad &

# wait for xmonad to stop
wait $!
