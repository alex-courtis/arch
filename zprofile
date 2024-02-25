# remove duplicates resulting from /etc/profile.d
typeset -U path

if [ "$(uname)" = "Darwin" ]; then
	# OSX moves these to the end of the path between zshenv and zprofile
	path=(~/bin ~/.local/bin $path)

	eval "$(/usr/local/bin/brew shellenv)"
fi

# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
if [ "${USER}" != "root" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" -a -n "${XDG_VTNR}" ]; then
	case "${XDG_VTNR}" in
		1)
			. startwm river
			;;
		2)
			. startwm x dwm
			;;
		3)
			. startwm steam
			;;
		4)
			. startwm hyprland
			;;
		5)
			. startwm sway
			;;
	esac
fi

# vim:ft=zsh
