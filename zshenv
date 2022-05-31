source "${HOME}/.zsh/zshenv.base16-bright"
source "${HOME}/.zsh/zshenv.function"

typeset -U path
path=(~/bin ~/.local/bin $path)

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# terminal preference
export TERMINAL="alacritty"

# better paging
export PAGER="less"

# git core.pager applies additional options
export LESS=Ri

# tell intellij that we're using a non-reparenting window manager
# maybe set suppress.focus.stealing=false custom setting
# pin any badly behaved popups
export _JAVA_AWT_NONREPARENTING=1
export _JAVA_AWT_WM_NONREPARENTING=1

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
HISTSIZE=10000
SAVEHIST=10000

# customise various bemenu invocations
export BEMENU_OPTS="--ignorecase \
	--prompt ':;' \
	--fn 'monospace 11' \
	--list 10 \
	--wrap \
	--sb '#FFFF00' --sf '#FFFFFF' \
	--tb '${BASE0B}' --tf '${BASE00}' \
	--fb '${BASE01}' --ff '${BASE04}' \
	--nb '${BASE01}' --nf '${BASE04}' \
	--hb '${BASE02}' --hf '${BASE06}'"

export XKB_DEFAULT_MODEL="pc105"
export XKB_DEFAULT_LAYOUT="us,us"
export XKB_DEFAULT_VARIANT="dvp,"
export XKB_DEFAULT_OPTIONS="caps:escape,grp:win_space_toggle"

