# replace this shell with tmux, attaching to detached if present
function starttmux() {
	if [ $(whence tmux) -a -z "${TMUX}" ]; then
		DETACHED="$( tmux ls 2>/dev/null | grep -vm1 attached | cut -d: -f1 )"
		if [ -z "${DETACHED}" ]; then
			exec tmux
		else
			exec tmux attach -t "${DETACHED}"
		fi
	fi
}

# If this is taking too long, throttle the checks. This will suit the use case of ssh to a remote existing session.
function updatetmuxenv() {
	if [ -n "${TMUX}" ]; then
		# Set a TERM appropriate for tmux, based on the "real terminal" that TMUX propagates.
		case $(tmux show-environment TERM 2>/dev/null) in
			*256color|*alacritty)
				TERM="tmux-256color"
				;;
			*)
				TERM="tmux"
				;;
		esac
		eval $(tmux show-environment -s SSH_CONNECTION)
	fi

	updatecolours
}

# one shot skipping execution of tmux
if [ ! -f "${HOME}/notmux" ] ; then
	starttmux
else
	rm "${HOME}/notmux"
fi

