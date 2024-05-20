typeset -U path
path=(~/bin ~/.local/bin $path)

source "${HOME}/.zsh/zshenv.appearance"
source "${HOME}/.zsh/zshenv.function"

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"

# git core.pager applies additional options
export LESS="--RAW-CONTROL-CHARS --ignore-case --quit-if-one-screen --chop-long-lines"
export SYSTEMD_LESS="${LESS}"

if [ "$(uname)" != "Darwin" ]; then
	# tell intellij that we're using a non-reparenting window manager
	# maybe set suppress.focus.stealing=false custom setting
	# pin any badly behaved popups
	export _JAVA_AWT_NONREPARENTING=1
	export _JAVA_AWT_WM_NONREPARENTING=1
fi

# some java build systems seem to like having JAVA_HOME set
if [ -L /usr/lib/jvm/default ]; then
	export JAVA_HOME=/usr/lib/jvm/default
fi

# allow use of "dev version" libraries under /usr/local/lib
export LD_LIBRARY_PATH="/usr/local/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

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

# it falls back to X successfully
export MOZ_ENABLE_WAYLAND=1

# suggest make behaviour
export MAKEFLAGS="-j"

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
export XKB_DEFAULT_OPTIONS="caps:escape,grp:shift_caps_toggle"
