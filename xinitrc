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
if [ "$(whence xlayoutdisplay)" ]; then
	xlayoutdisplay
fi

# start window manager
case "${X_WM}" in
	"dwm")
		slstatus &
		exec dwm
		;;
	*)
		print "unknown wm ${X_WM}" 1>&2
esac

