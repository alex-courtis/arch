#!/bin/zsh

# run all system xinitrc shell scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for script in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$script" -a ! -d "$script" ] && . "$script"
	done
fi

# merge .Xresources
if [ -r ${HOME}/.Xresources ]; then
	xrdb -load ${HOME}/.Xresources
fi

# setup displays before we start any applications
if [ "$(whence display-init)" ]; then
	display-init
fi

# start all the autostart apps
dapper --user-dir --system-dir --desktop alex >/dev/null 2>&1

# slock the screen after 5 mins
if [ "$(whence xautolock)" -a "$(whence slock)" ]; then
	xautolock -locker slock -time 5 &
fi

# numlock on
numlockx

# xbox wireless controller
if [ "$(whence xow)" ]; then
	xow > /tmp/xow.log 2>&1 &
fi

# start window manager
case "${X_WM}" in
	"dwm")
		slstatus &
		exec dwm
		;;
	"i3")
		exec i3
		;;
	*)
		print "unknown wm ${X_WM}" 1>&2
esac

