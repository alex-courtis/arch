# set path in here to remove duplicates resulting from /etc/profile.d
typeset -U path
path=(~/bin ~/.local/bin $path)

# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
# we need to test that we're outside tmux, as environment variables are inherited when starting new tmux sessions
if [ "${USER}" != "root" -a -z "${TMUX}" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" -a ! -f "${XDG_CONFIG_HOME}/nogui" ]; then
	case "${XDG_VTNR}" in
		1)
			if [ "$(hostname)" = "emperor" ]; then
				exec startwm x i3
			else
				exec startwm sway
			fi
			;;
		2)
			exec startwm x i3
			;;
		3)
			exec startwm x dwm
			;;
		4)
			exec startwm river
			;;
	esac
fi

