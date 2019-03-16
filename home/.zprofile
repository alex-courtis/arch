# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
# we need to test that we're outside tmux, as environment variables are inherited when starting new tmux sessions
if [ "${USER}" != "root" -a -z "${TMUX}" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" ]; then
	case "${XDG_VTNR}" in
	1|2)
		# according to man 5 xorg.conf an absolute directory should not be usable for a non root user
		startx -- -configdir "${HOME}/.config/X11/xorg.conf.d" > "/tmp/x.${USER}.log" 2>&1
		;;
	4)
		wdwm -s /home/tu/spawn.sh > "/tmp/wdwm.${USER}.log" 2>&1
		;;
	5)
		/home/alex/src/wlroots/tinywl/tinywl -s alacritty > "/tmp/tinywl.${USER}.log" 2>&1
		;;
	6)
		sway -d > "/tmp/sway.${USER}.log" 2>&1
		;;
	esac
fi
