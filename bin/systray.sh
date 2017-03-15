#!/bin/sh

# kill trayer if it is running
killall trayer >/dev/null 2>&1
if [ ${?} -eq 0 ]; then
    exit
fi

# start applets in background
[ $(type -t pasystray) ] && pasystray &
[ $(type -t nm-applet) ] && nm-applet &

# start trayer in foreground, centred at the top over xmobar
# default height is 26; use double that, multiplied by the DPI/96 and we are talking
trayer --edge top --align center --widthtype request --heighttype pixel --height 52 --transparent false --monitor 0

# kill applets
killall nm-applet
killall pasystray
