path=(~/bin $path)

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"

# case insensitive searching, raw escape sequence passthrough, skip single screen
export LESS=iRF

# tell old java apps that we're using a non-reparenting window manager
export _JAVA_AWT_WM_NONREPARENTING=1

# don't minimise fullscreen SDL (i.e. most steam) when losing focus
# they send a _NET_WM_STATE_FULLSCREEN _NET_WM_STATE_REMOVE however never send an ADD message on regaining focus
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

# some java build systems seem to like having JAVA_HOME set
if [ -L /usr/lib/jvm/default ]; then
	export JAVA_HOME=/usr/lib/jvm/default
fi

# allow use of "dev version" libraries under /usr/local/lib
export LD_LIBRARY_PATH="/usr/local/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

# unfortunately some apps need extra encouragement to follow the XDG base directory spec
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

# moar history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# dwm colours
COL_DWM_GRAY1="#222222"
COL_DWM_GRAY2="#444444"
COL_DWM_GRAY3="#bbbbbb"
COL_DWM_GRAY4="#eeeeee"
COL_DWM_CYAN="#005577"

# tmux colours
export COL_TMUX_NORM="fg=${COL_DWM_GRAY4},bg=${COL_DWM_CYAN}"

