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
# Too expensive for precmd.
# Manually invoke when attaching to an existing session from a different terminal type.
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

# maybe exec tmux
if [ ! -f "${HOME}/notmux" ] ; then
	tm
fi

# update TERM for tmux
if [ -n "${TMUX}" ]; then
	updatetmuxterm
fi
