# .xinitrc

function isAThing() {
    return $(type "${1}" > /dev/null 2>&1)
}

# Run all system xinitrc shell scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$script" -a ! -d "$script" ] && . "$script"
    done
fi

# merge local resources
if [ -f "${HOME}/.Xresources" ]; then
    xrdb -merge "${HOME}/.Xresources"
fi

# load up nvidia settings
isAThing nvidia-settings && nvidia-settings --load-config-only

# setup displays
isAThing xLayoutDisplays && xLayoutDisplays

# ensure that we have a background set and a reasonable pointer
isAThing xsetroot && xsetroot -solid gray30 -cursor_name left_ptr

# slock the screen after 5 mins
isAThing xautolock && isAThing slock && xautolock -locker slock -time 5 &

# start touchpad gesture recogniser
isAThing libinput-gestures && libinput-gestures &

# clear any xmonad saved state
rm -f .xmonad/xmonad.state

# start up nm-applet, for use by networkmanager_dmenu
# it won't be shown without a tray however is necessary to spawn windows
isAThing nm-applet && nm-applet > /dev/null 2>&1 &

if isAThing xmonad; then
    # start xmonad
    xmonad &

    # wait for xmonad to stop
    wait $!
else
    # start a terminal
    st
fi
