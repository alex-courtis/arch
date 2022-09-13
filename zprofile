# remove duplicates resulting from /etc/profile.d
typeset -U path

# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
# we need to test that we're outside tmux, as environment variables are inherited when starting new tmux sessions
if [ "${USER}" != "root" -a -z "${TMUX}" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" -a -n "${XDG_VTNR}" ]; then
	if [ -f "${HOME}/nowm" ]; then
		touch "${HOME}/notmux"
	else
		case "${XDG_VTNR}" in
			1)
				if [ "${HOST}" = "emperor" ]; then
					exec startwm x dwm
				else
					exec startwm river
				fi
				;;
			2)
				exec startwm x i3
				;;
			3)
				exec startwm x dwm
				;;
			4)
				exec startwm sway
				;;
		esac
	fi
fi

