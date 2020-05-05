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


# dwm colours for reference only
C_D_GRAY1="#222222"
C_D_GRAY2="#444444"
C_D_GRAY3="#bbbbbb"
C_D_GRAY4="#eeeeee"
C_D_CYAN="#005577"

# zsh colours
C_Z_O="%k%f%b"
C_Z_E="%F{black}%K{red}"
C_Z_W="%F{black}%K{yellow}"
C_Z_N="%F{${C_D_GRAY4}}%K{${C_D_CYAN}}"

# tmux colours
export C_T_N="fg=${C_D_GRAY4},bg=${C_D_CYAN}"


# maybe exec tmux
if [ ! -f "${HOME}/notmux" ] ; then
	tm
fi
if [ -n "${TMUX}" ]; then
	updatetmuxterm
fi

# remove duplicates coming from arch's /etc/profile.d
typeset -U path


# zsh completion
zstyle ':completion:*:*:*:*:*' menu select
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

# shift tab
bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete

# search up to cursor
bindkey -M viins "^J" history-beginning-search-forward
bindkey -M viins "^K" history-beginning-search-backward

# incremental search which uses a limited set of regular bindings, overridden by the (empty) isearch map
bindkey -M viins "^F" history-incremental-search-forward
bindkey -M viins "^B" history-incremental-search-backward

# not using any esc, something sequences so drop the timeout from 40 for better editing responsiveness
KEYTIMEOUT=1


# vim beam/block cursor style; using the same VTE values as vim terminus plugin
# block/nomal: 2
# underscore/replace: 4 (not yet...)
# beam/insert: 6
# cannot find any terminfo entries for these, so hardcode
function updatecursor() {
	case ${KEYMAP} in
		(vicmd)
			printf "\033[2 q"
			;;
		(*)
			printf "\033[6 q"
			;;
	esac
}
zle -N zle-line-init updatecursor
zle -N zle-keymap-select updatecursor
function resetcursor() {
	printf "\033[2 q"
}
zle -N zle-line-finish resetcursor


# git PS1
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
	GIT_PS1_SHOWDIRTYSTATE="true"
	GIT_PS1_SHOWSTASHSTATE="true"
	GIT_PS1_SHOWUPSTREAM="auto"
	. /usr/share/git/completion/git-prompt.sh
else
	function __git_ps1() { : }
fi

# prompts
PR_STA="${C_Z_N}:${C_Z_O}"
PR_ERR="%(?..${C_Z_E} %? ${C_Z_O})"
if [ -z "${TMUX}" ]; then
	PR_WAR="${C_Z_W} -tm ${C_Z_O}"
fi
PR_END="${C_Z_N};${C_Z_O}"
PS1="${PR_STA}${PR_WAR}${PR_ERR}${PR_END} "
PS2="${C_Z_N}%_>${C_Z_O} "
PS3="${C_Z_N}?#${PS3}${C_Z_O} "
PS4="${C_Z_N}+%N:%i>${C_Z_O} "
unset PR_STA PR_ERR PR_WAR PR_END

# title
if [ -n "${ALACRITTY_THEME}" ]; then
	THEME_INDICATOR=" {${ALACRITTY_THEME}}"
fi
function precmd() {
	print -Pn "${terminfo[tsl]}%~$(__git_ps1)${THEME_INDICATOR}${terminfo[fsl]}"
}


# use the keychain wrapper to start ssh-agent if needed
if [ $(whence keychain) -a -f ~/.ssh/id_rsa ]; then
	eval $(keychain --eval --quiet --agents ssh ~/.ssh/id_rsa)
fi


# general aliases
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
alias pt='pstree -TapU -C age'
alias ptw='watch -t -n 0.5 -c pstree -TapU -C age'
alias agh='ag --hidden'
alias todo='todo.sh'
alias vidone='vi ~/.todo/todotxt/done.txt'
alias vitodo='vi ~/.todo/todotxt/todo.txt'

# music management aliases
alias music-home-to-lord="rsync -a -v --omit-dir-times --delete-after \${HOME}/music/ /net/lord/music/"
alias music.arch-home-to-lord="rsync -a -v --omit-dir-times --delete-after \${HOME}/music.arch/ /net/lord/music.arch/"
alias music-lord-to-home="rsync -a -v --omit-dir-times --delete-after /net/lord/music/ \${HOME}/music/"
alias music.arch-lord-to-home="rsync -a -v --omit-dir-times --delete-after /net/lord/music.arch/ \${HOME}/music.arch/"
alias music-home-to-android="adb-sync --delete \${HOME}/music/ /sdcard/Music"
alias music-lord-to-android="adb-sync --delete /net/lord/music/ /sdcard/Music"
alias music-android-to-home="adb-sync --delete --reverse /sdcard/Music/ \${HOME}/music"

colours
