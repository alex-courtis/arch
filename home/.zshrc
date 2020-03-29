# shell agnostic function returns true if ${1} is a valid executable, function etc.
function haz() {
	return $(type "${1}" > /dev/null 2>&1)
}

# maybe run tmux: replace this shell with a new login shell
if haz tmux && [ -z "${TMUX}" ] && [ -f "${HOME}/.tmux.conf" ] && [ ! -f "${HOME}/notmux" ] ; then
	DETACHED="$( tmux ls 2>/dev/null | grep -vm1 attached | cut -d: -f1 )"

	if [ -z "${DETACHED}" ]; then
		exec tmux
	else
		exec tmux attach -t "${DETACHED}"
	fi
fi

# if we've got to this point and tmux is not running, replace the vim unfriendly alacritty term
if [ "${TERM}" = "alacritty" ]; then
	TERM="xterm-256color"
fi

# zsh on arch will source /etc/profile and thus the scripts in /etc/profile.d for each login shell, some of which will append duplicates, hence we need to invoke this typeset to remove any dupes
typeset -U path

# ensure that these are at the very end of the path, to prevent clobbering of system utils e.g. xpath, nvm
[[ -d ~/src/atlassian-scripts ]] && path=("$path[@]" ~/src/atlassian-scripts/bin)

# boot the zsh completion system
autoload -Uz compinit
compinit

# moar history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# vim zle mode with proper deletes
bindkey -v
bindkey -M viins "${terminfo[kdch1]}" delete-char
bindkey -M vicmd "${terminfo[kdch1]}" delete-char

# search up to cursor
bindkey -M viins "^J" history-beginning-search-forward
bindkey -M viins "^K" history-beginning-search-backward

# incremental search which uses a limited set of regular bindings, overridden by the (empty) isearch map
bindkey -M viins "^B" history-incremental-search-backward

# remove some escape,something bindings added by compinit
# don't try setting KEYTIMEOUT=1 as that can prevent useful sequences like arrow keys
bindkey -M viins -r "^[/"
bindkey -M viins -r "^[,"

# common aliases
alias ls="ls --color=auto"
alias ll="ls -lh"
alias lla="ll -a"
alias grep="grep --color=auto"
alias grepc="grep --color=always"
alias diff="diff --color=auto"
alias diffc="diff --color=always"
alias rgrep="find . -type f -print0 | xargs -0 grep --color=auto"
alias rgrepc="find . -type f -print0 | xargs -0 grep --color=always"
alias diffp="diff -Naur"
alias pt='pstree -Tap -C age'
alias wpt='watch -t -n 0.5 -c pstree -TapU -C age'

# prompt:
#   bg red background nonzero return code and newline
#   bg host background coloured ":; " in black text
PS1="%(?..%F{black}%K{red}%?%k%f"$'\n'")%F{black}%K{${HOST_COLOUR}}:;%k%f "
PS2="%K{${HOST_COLOUR}}:; %_%k "

# title pwd and __git_ps1 (if present)
#   "\e]0;" ESC xterm (title) code
#   "\a"	BEL
[[ -f /usr/share/git/completion/git-prompt.sh ]] && . /usr/share/git/completion/git-prompt.sh
if haz __git_ps1; then

	# show extra flags
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWSTASHSTATE=true
	precmd() {
		printf "\e]0;%s%s\a" "${PWD}" "$(__git_ps1)"
	}
else
	precmd() {
		printf "\e]0;%s\a" "${PWD}"
	}
fi

# user mount helpers
if haz udisksctl; then
	mnt() {
		if [ ${#} -ne 1 ]; then
			echo "Usage: ${FUNCNAME} <block device>" >&2
			return 1
		fi
		udisksctl mount -b ${1} && cd "$(findmnt -n -o TARGET ${1})"
	}
	umnt() {
		if [ ${#} -ne 1 ]; then
			echo "Usage: ${FUNCNAME} <block device>" >&2
			return 1
		fi
		udisksctl unmount -b ${1}
	}
fi

# music management utilities
if haz rsync; then
	alias music-home-to-lord="rsync -a -v --omit-dir-times --delete-after \${HOME}/music/ /net/lord/music/"
	alias music.arch-home-to-lord="rsync -a -v --omit-dir-times --delete-after \${HOME}/music.arch/ /net/lord/music.arch/"
	alias music-lord-to-home="rsync -a -v --omit-dir-times --delete-after /net/lord/music/ \${HOME}/music/"
	alias music.arch-lord-to-home="rsync -a -v --omit-dir-times --delete-after /net/lord/music.arch/ \${HOME}/music.arch/"
fi
if haz adb-sync; then
	alias music-home-to-android="adb-sync --delete \${HOME}/music/ /sdcard/Music"
	alias music-lord-to-android="adb-sync --delete /net/lord/music/ /sdcard/Music"
	alias music-android-to-home="adb-sync --delete --reverse /sdcard/Music/ \${HOME}/music"
fi

# use the keychain wrapper to start ssh-agent if needed
if haz keychain && [ -f ~/.ssh/id_rsa ]; then
	eval $(keychain --eval --quiet --agents ssh ~/.ssh/id_rsa)
fi
