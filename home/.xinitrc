function haz() {
        return $(type "${1}" > /dev/null 2>&1)
}

function maybe() {
	! haz "${1}" || "${@}"
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
maybe xlayoutdisplay

# start all the autostart apps
maybe dex -a -v

# slock the screen after 5 mins
maybe xautolock -locker slock -time 5 &

# numlock on
maybe numlockx

# start window manager
slstatus &
exec dwm >> "${DE_LOG_DIR}/dwm.stdout" 2>> "${DE_LOG_DIR}/dwm.stderr"
