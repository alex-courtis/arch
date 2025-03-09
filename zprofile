echo "zprofile ${$} ${ZSH_EXECUTION_STRING}" >> /tmp/zsh.${XDG_VTNR-x}.${USER}.log

[ -f "${HOME}/.zprofile.host" ] && . "${HOME}/.zprofile.host"

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
