# shell agnostic function returns true if ${1} is a valid executable, function etc.
function haz() {
	return $(type "${1}" > /dev/null 2>&1)
}

# run all system xinitrc shell scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for script in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$script" -a ! -d "$script" ] && . "$script"
	done
fi

# merge .Xresources, in case we're running without any sort of display manager
if [ -r ${HOME}/.Xresources ]; then
	xrdb -load ${HOME}/.Xresources
fi

# setup displays before we start any applications
haz xlayoutdisplay && xlayoutdisplay

# start all the autostart apps
haz dex && dex -a

# slock the screen after 5 mins
haz xautolock && haz slock && xautolock -locker slock -time 5 &

# start window manager
slstatus &
exec dwm 

