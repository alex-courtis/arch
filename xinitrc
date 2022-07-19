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

# slock the screen after 5 mins
if [ "$(whence xautolock)" -a "$(whence slock)" ]; then
	xautolock -locker slock -time 5 &
fi

# numlock on
numlockx

# Xorg doesn't read these
setxkbmap -model "${XKB_DEFAULT_MODEL}"
setxkbmap -layout "${XKB_DEFAULT_LAYOUT}"
setxkbmap -variant "${XKB_DEFAULT_VARIANT}"
setxkbmap -option "${XKB_DEFAULT_OPTIONS}"

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

