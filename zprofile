# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
# we need to test that we're outside tmux, as environment variables are inherited when starting new tmux sessions
if [ "${USER}" != "root" -a -z "${TMUX}" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" ]; then
	case "${XDG_VTNR}" in
		1)
			exec startwm sway
			;;
		2)
			exec startwm x i3
			;;
		3)
			exec startwm x dwm
			;;
		4)
			exec startwm weston
			;;
		5)
			exec startwm tinywl
			;;
	esac
fi

