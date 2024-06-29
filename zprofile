echo "zprofile ${$} ${ZSH_EXECUTION_STRING}" >> /tmp/zsh_sessions.log
[ "${UNAME}" = "Linux" ] && bell

# TODO extract to host-
# OSX moves these to the end of the path between zshenv and zprofile
if [ "${UNAME}" = "Darwin" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"

	path=($(brew --prefix)/opt/util-linux/sbin $(brew --prefix)/opt/util-linux/bin $path)

	eval "$(mise activate zsh)"

	path=(~/bin ~/.local/bin $path)
fi

# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
if [ "${USER}" != "root" -a "${HOST}" != "lord" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" -a -n "${XDG_VTNR}" ]; then
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
