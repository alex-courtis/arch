# remove duplicates resulting from /etc/profile.d
typeset -U path

if [ "$(uname)" = "Darwin" ]; then
	# OSX moves these to the end of the path between zshenv and zprofile
	path=(~/bin ~/.local/bin $path)

	eval "$(/usr/local/bin/brew shellenv)"
fi

# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
# we need to test that we're outside tmux, as environment variables are inherited when starting new tmux sessions
if [ "${USER}" != "root" -a -z "${TMUX}" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" -a -n "${XDG_VTNR}" ]; then
	if [ -f "${HOME}/nowm" ]; then
		touch "${HOME}/notmux"
	else
		case "${XDG_VTNR}" in
			1)
				exec startwm river
				;;
			2)
				exec startwm x dwm
				;;
			3)
				exec startwm hyprland
				;;
			4)
				exec startwm sway
				;;
		esac
	fi
fi

