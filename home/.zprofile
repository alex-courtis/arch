# maybe start a GUI if one isn't running; flavour depends on which virtual terminal we are on
# we need to test that we're outside tmux, as environment variables are inherited when starting new tmux sessions
if [ "${USER}" != "root" -a -z "${TMUX}" -a -z "${DISPLAY}" ]; then
	case "${XDG_VTNR}" in
	"1")
		# according to man 5 xorg.conf an absolute directory should not be usable for a non root user
		startx -- -configdir "${HOME}/.config/X11/xorg.conf.d" > "${HOME}/.x.log" 2>&1
		;;
	"2")
		/home/alex/src/wlroots/tinywl/tinywl -s alacritty > "${HOME}/.tinywl.log" 2>&1
		;;
	"3")
		sway > "${HOME}/.sway.log" 2>&1
		;;
	esac
fi
