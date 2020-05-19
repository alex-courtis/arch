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
#xlayoutdisplay
echo "Xft.dpi: $(xdpyinfo | grep "resolution" | sed -e 's/^.*resolution: *//g ; s/x.*$//g')" | xrdb -merge

# start all the autostart apps
dapper --user-dir --system-dir --desktop alex

# slock the screen after 5 mins
if [ "$(whence xautolock)" -a "$(whence slock)" ]; then
	xautolock -locker slock -time 5 &
fi

# numlock on
numlockx

# start window manager
slstatus >/dev/null 2>&1 &
exec dwm >/dev/null 2>&1
