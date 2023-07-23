# maybe execute tmux, not on vt6, attaching to detached if present
if [ ! -f "${HOME}/notmux" ] ; then
	if [ "$(whence tmux)" -a -z "${TMUX}" -a "${XDG_VTNR}" -ne 6 -a "${NOTMUX}" != "true" ]; then
		DETACHED="$(tmux ls -F '#{session_name}' -f '#{?session_attached,0,1}' 2>/dev/null | grep -vm1 '\-lurking$')"
		if [ -z "${DETACHED}" ]; then
			exec tmux
		else
			exec tmux attach -t "${DETACHED}"
		fi
	fi
else
	rm ${HOME}/notmux
fi

# update SSH_CONNECTION from tmux env
function updatetmuxssh() {
	if [ -n "${TMUX}" ]; then
		eval $(tmux show-environment -s SSH_CONNECTION)
	fi
}

# apply COL_TMUX to the session, only on change
COL_TMUX_PREV=""
function updatetmuxcolours() {
	if [ -n "${TMUX}" -a "${COL_TMUX}" != "${COL_TMUX_PREV}" ]; then
		tmux set status-style "${COL_TMUX}"
		tmux set message-style "${COL_TMUX}"
		tmux set-window-option mode-style "${COL_TMUX}"
		COL_TMUX_PREV="${COL_TMUX}"
	fi
}

