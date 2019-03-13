# .zshenv is invoked when a login shell is started; zsh on arch will source /etc/profile and thus the scripts in /etc/profile.d for each login shell, some of which will append to the path
typeset -U path
[[ -d ~/bin ]] && path=(~/bin "$path[@]")

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"

# case insensitive searching and colours
export LESS="IR"

# keep this synced with 90-keyboard.conf, until X goes away
case "$(hostname)" in
duke*)
	export XKB_DEFAULT_OPTIONS="ctrl:nocaps,altwin:swap_alt_win"
	;;
* )
	export XKB_DEFAULT_OPTIONS="ctrl:nocaps"
	;;
esac

# tell old java apps that we're using a non-reparenting window manager
export _JAVA_AWT_WM_NONREPARENTING=1

# some java build systems seem to like having JAVA_HOME set
if [ -L /usr/lib/jvm/default ]; then
	export JAVA_HOME=/usr/lib/jvm/default
fi

# allow use of "dev version" libraries under /usr/local/lib
export LD_LIBRARY_PATH="/usr/local/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
