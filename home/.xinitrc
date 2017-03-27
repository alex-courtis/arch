# .xinitrc

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

# ensure that we have a background set and a reasonable pointer
[ $(type -t xsetroot) ] && xsetroot -solid gray30 -cursor_name left_ptr

# setup displays
[ $(type -t xLayoutDisplays) ] && xLayoutDisplays

# slock the screen after 5 mins
[ $(type -t xautolock) ] && [ $(type -t slock) ] && xautolock -locker slock -time 5 &

# start touchpad gesture recogniser
[ $(type -t libinput-gestures-setup) ] && libinput-gestures-setup start > /dev/null 2>&1

# clear any xmonad saved state
rm -f .xmonad/xmonad.state

# start up nm-applet, for use by networkmanager_dmenu
# it won't be shown without a tray however is necessary to spawn windows
[ $(type -t nm-applet) ] && nm-applet > /dev/null 2>&1 &

# temporary dpi hardcoded overrides
if [ $(hostname) = "gigantor" ]; then
    echo "Xft.dpi: 168" | xrdb -merge
fi
if [ $(hostname) = "duke" ]; then
    echo "Xft.dpi: 144" | xrdb -merge
fi

if [ $(type -t xmonad) ]; then
    # start xmonad
    xmonad &

    # wait for xmonad to stop
    wait $!
else
    # start a terminal
    urxvt
fi

# stop touchpad gesture recogniser
[ $(type -t libinput-gestures-setup) ] && libinput-gestures-setup stop > /dev/null 2>&1
