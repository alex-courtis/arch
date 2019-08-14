# shell agnostic function returns true if ${1} is a valid executable, function etc.
function haz() {
	return $(type "${1}" > /dev/null 2>&1)
}

# select host prompt colour (used by tmux) from: black, red, green, yellow, blue, magenta, cyan, white
export PROMPT_COLOUR
case "$(hostname)" in
emperor*)
	PROMPT_COLOUR="yellow"
	;;
gigantor*)
	PROMPT_COLOUR="blue"
	;;
lord*)
	PROMPT_COLOUR="magenta"
	;;
* )
	PROMPT_COLOUR="cyan"
	;;
esac

# root prompt is always red
if [ "${USER}" = "root" ]; then
	PROMPT_COLOUR="red"
fi

# execute tmux if it isn't running; it will replace this process with a new login shell
if haz tmux && [ -z "${TMUX}" ] && [ -f "${HOME}/.tmux.conf" ] && [ -z "${VSCODE_CLI}" ]; then
	exec tmux
fi

# zsh on arch will source /etc/profile and thus the scripts in /etc/profile.d for each login shell, some of which will append duplicates, hence we need to invoke this typeset to remove any dupes
typeset -U path

# ensure that these are at the very end of the path, to prevent clobbering of system utils e.g. xpath, nvm
[[ -d ~/src/robbieg.bin ]] && path=("$path[@]" ~/src/robbieg.bin)
[[ -d ~/src/atlassian-scripts ]] && path=("$path[@]" ~/src/atlassian-scripts/bin)

# moar history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# vim CLI mode
bindkey -v

# boot the zsh completion system 
autoload -Uz compinit
compinit

# bindings for insert mode
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward

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

# prompt:
#   bg red background nonzero return code and newline
#   bg host background coloured ":; " in black text
PS1="%(?..%F{black}%K{red}%?%k%f"$'\n'")%F{black}%K{${PROMPT_COLOUR}}:;%k%f "
PS2="%K{${PROMPT_COLOUR}}:; %_%k "

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
