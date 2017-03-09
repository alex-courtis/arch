# .xinitrc

# Run all system xinitrc shell scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$script" -a ! -d "$script" ] && . "$script"
    done
fi

# ensure that we have a background set and a reasonable pointer
[ -f /usr/bin/xsetroot ] && xsetroot -solid gray20 -cursor_name left_ptr

# setup displays
[ -f ~/bin/autoDetectDisplays.sh ] && ~/bin/autoDetectDisplays.sh

# trayer top right, first monitor
[ -f /usr/bin/trayer ] && /usr/bin/trayer --edge top --align right --widthtype request --heighttype request --transparent true --alpha 0 --tint 0x333333 --monitor 0 &

# lock the screen after 5 mins, using i3lock as the "locker" after 5 mins and suspend as the "killer" after 10 mins after that
[ -f /usr/bin/xautolock ] && [ -f /usr/bin/i3lock ] && xautolock -locker 'i3lock -e -c 888888' -time 5 -killer 'systemctl suspend' -killtime 10 &

# applets/system tray apps
[ -f /usr/bin/pasystray ] && /usr/bin/pasystray &
[ -f /usr/bin/nm-applet ] && /usr/bin/nm-applet &

# disable touchpad while and 2 sec after typing
[ -f /usr/bin/syndaemon ] && /usr/bin/syndaemon -i 0.5 -d

# clear any xmonad saved state
rm .xmonad/xmonad.state

# start xmonad
xmonad &

# wait for xmonad to stop
wait $!
