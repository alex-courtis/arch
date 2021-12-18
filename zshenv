source "${HOME}/.zsh/zshenv.base16-bright"
source "${HOME}/.zsh/zshenv.function"

path=(~/bin ~/.local/bin $path)

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# terminal preference
export TERMINAL="alacritty"

# better paging
export PAGER="less"

# case insensitive searching, raw escape sequence passthrough
export LESS=iR

# tell old java apps that we're using a non-reparenting window manager
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

# shell and tmux colours
COL_ZSH_OFF="%k%f"
COL_ZSH_WAR="%F{black}%K{yellow}"
COL_ZSH_ERR="%F{black}%K{red}"
if [ "${USER}" = "root" ]; then
	COL_ZSH_NOR="%F{black}%K{red}"
	export COL_TMUX_NORM="fg=black,bg=red"
elif [ -n "${SSH_CONNECTION}" ]; then
	COL_ZSH_NOR="%F{black}%K{magenta}"
	export COL_TMUX_NORM="fg=black,bg=magenta"
else
	COL_ZSH_NOR="%F{black}%K{green}"
	export COL_TMUX_NORM="fg=black,bg=green"
fi

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

