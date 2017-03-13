# .xinitrc

# Run all system xinitrc shell scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$script" -a ! -d "$script" ] && . "$script"
    done
fi

# ensure that we have a background set and a reasonable pointer
[ $(type -t xsetroot) ] && xsetroot -solid gray30 -cursor_name left_ptr

# setup displays
[ $(type -t autoDetectDisplays.sh) ] && autoDetectDisplays.sh

# i3lock (grey30 background) is the screen "locker" after 5 mins and suspend as the "killer" 10 mins after that
[ $(type -t xautolock) ] && [ $(type -t i3lock) ] && xautolock -locker 'i3lock -e -c 4D4D4D' -time 5 -killer 'systemctl suspend' -killtime 10 &

# disable touchpad while and 2 sec after typing
[ $(type -t syndaemon) ] && syndaemon -i 0.5 -d

# clear any xmonad saved state
rm -f .xmonad/xmonad.state

if [ $(type -t xmonad) ]; then
    # start xmonad
    xmonad &

    # wait for xmonad to stop
    wait $!
else
    # start a terminal
    urxvt
fi
