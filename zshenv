echo "zshenv   ${$} ${ZSH_EXECUTION_STRING}" >> /tmp/zsh.${XDG_VTNR-x}.${USER}.log

typeset -U path
path=(~/bin ~/.local/bin $path)

source "${HOME}/.zsh/zshenv.appearance"
source "${HOME}/.zsh/zshenv.function"

export UNAME="$(uname)"

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"
# except git commit, rebase etc.
export GIT_EDITOR="vim"

# fallback for xdg-open
export BROWSER="b"

# better paging
export PAGER="less"

# git core.pager applies additional options
export LESS="--RAW-CONTROL-CHARS --ignore-case --quit-if-one-screen --chop-long-lines"
export SYSTEMD_LESS="${LESS}"

# XDG_RUNTIME_DIR and others set by systemd
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# don't minimise fullscreen SDL (i.e. most steam) when losing focus
# they send a _NET_WM_STATE_FULLSCREEN _NET_WM_STATE_REMOVE however never send an ADD message on regaining focus
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

# moar history
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# suggest make behaviour
export MAKEFLAGS="-j12"

# man colours
#  errors:    reverse as normal
#  prompt:    reverse as normal
#  results:   reverse as normal
#  bold:      blue
#  blink:     red
#  standout:  magenta
#  underline: green, remove underline
export MANPAGER="less --use-color \
	--color=E+kw \
	--color=P+kw \
	--color=S+kw \
	--color=d+b \
	--color=k+r \
	--color=s+m \
	--color=ug \
"
export MANROFFOPT="-P -c"

export XKB_DEFAULT_MODEL="pc105"
export XKB_DEFAULT_LAYOUT="us,us"
export XKB_DEFAULT_VARIANT="dvp,"
export XKB_DEFAULT_OPTIONS="caps:escape,grp:alt_caps_toggle"

if [ "$(whence luarocks)" ]; then
	eval "$(luarocks path)"
fi

if [ "${UNAME}" != "Darwin" ] && [ -z "${RDE_PROFILE_NAME}" ] || [ -n "${TMUX}" ]; then
	export TERM_TITLE="true"
fi
if [ -n "${SSH_CONNECTION}" ] && [ -z "${RDE_PROFILE_NAME}" ]; then
	export PS1_HOST="true"
fi
if [ "${USER}" != "alex" ] && [ "${USER}" != "acourtis" ] && [ "${USER}" != "ubuntu" ]; then
	export PS1_HOST="true"
	export PS1_USER="true"
fi

