echo "zshrc    ${$} ${ZSH_EXECUTION_STRING}" >> /tmp/zsh_sessions.${USER}.log

fpath=(${XDG_DATA_HOME}/zsh/site-functions /opt/homebrew/share/zsh/site-functions $fpath)

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
