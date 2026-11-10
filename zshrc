fpath=(${XDG_DATA_HOME}/zsh/site-functions $fpath)

[ -f "${HOME}/.zshrc.host" ] && source "${HOME}/.zshrc.host"

source "${HOME}/.zsh/zshrc.completion"
source "${HOME}/.zsh/zshrc.zle"
source "${HOME}/.zsh/zshrc.fzf"
source "${HOME}/.zsh/zshrc.prompt"
source "${HOME}/.zsh/zshrc.function"
source "${HOME}/.zsh/zshrc.plugins"
source "${HOME}/.zsh/zshrc.alias"

# use the keychain wrapper to start ssh-agent if needed
if [ "$(whence keychain)" ]; then
	if [ "${XDG_RUNTIME_DIR}" ] && [ "${DBUS_SESSION_BUS_ADDRESS}" ]; then
		eval $(keychain --eval --systemd --quiet --immediate id_ed25519 )
	else
		eval $(keychain --eval           --quiet --immediate id_ed25519 )
	fi
fi

setopt rmstarsilent

if [ -n "${TMUX}" ]; then
	tmux list-keys | grep -E 'send-prefix$|copy-mode$|clear-history'
fi
