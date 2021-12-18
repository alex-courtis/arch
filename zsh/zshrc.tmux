# replace this shell with tmux, attaching to detached if present
function tm() {
	if [ $(whence tmux) -a -z "${TMUX}" ]; then
		DETACHED="$( tmux ls 2>/dev/null | grep -vm1 attached | cut -d: -f1 )"
		if [ -z "${DETACHED}" ]; then
			exec tmux
		else
			exec tmux attach -t "${DETACHED}"
		fi
	fi
}

# Set a TERM appropriate for tmux, based on the "real terminal" that TMUX propagates.
function updatetmuxterm() {
	if [ -n "${TMUX}" ]; then
		case $(tmux show-environment TERM 2>/dev/null) in
			*256color|*alacritty)
				TERM="tmux-256color"
				;;
			*)
				TERM="tmux"
				;;
		esac
	fi
}

# one shot skipping execution of tmux
if [ ! -f "${HOME}/notmux" ] ; then
	tm
else
	rm ${HOME}/notmux
fi

# style tmux
if [ -n "${TMUX}" ]; then
	tmux set status-style "${COL_TMUX_NORM}"
	tmux set message-style "${COL_TMUX_NORM}"
	tmux set-window-option mode-style "${COL_TMUX_NORM}"
fi

