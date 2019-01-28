# see .zshrc for full path enumeration
typeset -U path
[[ -d ~/bin ]] && path=(~/bin "$path[@]")

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"

# case insensitive searching and colours
export LESS="IR"

# tell old java apps that we're using a non-reparenting window manager
export _JAVA_AWT_WM_NONREPARENTING=1

# some java build systems seem to like this
export JAVA_HOME=/usr/lib/jvm/default
