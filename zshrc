fpath=(${XDG_DATA_HOME}/zsh/site-functions /opt/homebrew/share/zsh/site-functions $fpath)

PS1_TITLE="false"
if [ "${UNAME}" = "Darwin" ] || [ -z "${RDE_PROFILE_NAME}" ]; then
	if [ -z "${TMUX}" ]; then
		PS1_TITLE="true"
	fi
fi

source "${HOME}/.zsh/zshrc.completion"
source "${HOME}/.zsh/zshrc.zle"
source "${HOME}/.zsh/zshrc.fzf"
source "${HOME}/.zsh/zshrc.prompt"
source "${HOME}/.zsh/zshrc.function"
source "${HOME}/.zsh/zshrc.alias"

# use the keychain wrapper to start ssh-agent if needed
if [ "$(whence keychain)" -a -f ~/.ssh/id_rsa ]; then
	eval $(keychain --eval --quiet --agents ssh ~/.ssh/id_rsa)
fi

setopt rmstarsilent
