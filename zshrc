source "${HOME}/.zsh/zshrc.completion"
source "${HOME}/.zsh/zshrc.zle"
source "${HOME}/.zsh/zshrc.function"
source "${HOME}/.zsh/zshrc.prompt"
source "${HOME}/.zsh/zshrc.alias"
source "${HOME}/.zsh/zshrc.tmux"

# remove duplicates coming from arch's /etc/profile.d
typeset -U path

# use the keychain wrapper to start ssh-agent if needed
if [ $(whence keychain) -a -f ~/.ssh/id_rsa ]; then
	eval $(keychain --eval --quiet --agents ssh ~/.ssh/id_rsa)
fi

updatetmuxenv

