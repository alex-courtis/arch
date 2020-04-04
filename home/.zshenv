# .zshenv is invoked when a login shell is started; zsh on arch will source /etc/profile and thus the scripts in /etc/profile.d for each login shell, some of which will append to the path
typeset -U path
[[ -d ~/bin ]] && path=(~/bin "$path[@]")

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"

# case insensitive searching and colours
export LESS="iR"

# keep this synced with 90-keyboard.conf, until X goes away
export XKB_DEFAULT_LAYOUT="us"
export XKB_DEFAULT_MODEL="pc105"
export XKB_DEFAULT_VARIANT="dvp"
export XKB_DEFAULT_OPTIONS="caps:backspace"

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

# select host colour for prompts, tmux
export HOST_COLOUR
if [ "${USER}" = "root" ]; then
	HOST_COLOUR="red"
else
	case "$(hostname)" in
	emperor*)
		HOST_COLOUR="yellow"
		;;
	gigantor*)
		HOST_COLOUR="blue"
		;;
	lord*)
		HOST_COLOUR="magenta"
		;;
	* )
		HOST_COLOUR="cyan"
		;;
	esac
fi
