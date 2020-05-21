source "${HOME}/.zshrc.tmux"
source "${HOME}/.zshrc.completion"
source "${HOME}/.zshrc.zle"
source "${HOME}/.zshrc.prompt"
source "${HOME}/.zshrc.function"
source "${HOME}/.zshrc.alias"

# remove duplicates coming from arch's /etc/profile.d
typeset -U path

# use the keychain wrapper to start ssh-agent if needed
if [ $(whence keychain) -a -f ~/.ssh/id_rsa ]; then
	eval $(keychain --eval --quiet --agents ssh ~/.ssh/id_rsa)
fi

colours-base16

