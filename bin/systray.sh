#!/bin/sh

# kill trayer if it is running
killall trayer
if [ ${?} -eq 0 ]; then
    exit
fi

# start applets in background
[ $(type -t pasystray) ] && pasystray &
[ $(type -t nm-applet) ] && nm-applet &

# start trayer in foreground, centred at the top over xmobar
trayer --edge top --align center --widthtype request --heighttype request --transparent true --alpha 0 --tint 0x333333 --monitor 0

# kill applets
killall nm-applet
killall pasystray
