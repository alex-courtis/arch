[ "${ZSH_PROFILE_STARTUP}" ] && zmodload zsh/zprof

echo "zshrc    ${$} ${ZSH_EXECUTION_STRING}" >> /tmp/zsh.${XDG_VTNR-x}.${USER}.log

fpath=(${XDG_DATA_HOME}/zsh/site-functions /opt/homebrew/share/zsh/site-functions $fpath)

source "${HOME}/.zsh/zshrc.completion"
source "${HOME}/.zsh/zshrc.zle"
source "${HOME}/.zsh/zshrc.fzf"
source "${HOME}/.zsh/zshrc.prompt"
source "${HOME}/.zsh/zshrc.function"
source "${HOME}/.zsh/zshrc.alias"

# use the keychain wrapper to start ssh-agent if needed
if [ "$(whence keychain)" ]; then
	if [ "${XDG_RUNTIME_DIR}" ] && [ "${DBUS_SESSION_BUS_ADDRESS}" ]; then
		eval $(keychain --eval --systemd --quiet id_rsa )
	else
		eval $(keychain --eval           --quiet id_rsa )
	fi
fi

setopt rmstarsilent

[ "${ZSH_PROFILE_STARTUP}" ] && echo "====zshrc=======" && zprof && zprof -c && echo
