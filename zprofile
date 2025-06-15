[ "${ZSH_PROFILE_STARTUP}" ] && zmodload zsh/zprof

echo "zprofile ${$} ${ZSH_EXECUTION_STRING}" >> /tmp/zsh.${XDG_VTNR-x}.${USER}.log

# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
if [ "${USER}" != "root" -a "${HOST}" != "lord" -a -z "${DISPLAY}" -a -z "${WAYLAND_DISPLAY}" -a -n "${XDG_VTNR}" ]; then
	case "${XDG_VTNR}" in
		1)
			. de-river
			;;
		2)
			. de-dwm
			;;
		3)
			. de-gamescope-steam
			;;
	esac
fi

[ "${ZSH_PROFILE_STARTUP}" ] && echo "====zprofile====" && zprof && zprof -c && echo

# vim:ft=zsh
