typeset -U path
[[ -d ~/bin ]] && path=(~/bin "$path[@]")

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"

# case insensitive searching and colours
export LESS="IR"

# die caps lock
export XKB_DEFAULT_OPTIONS="ctrl:nocaps"

# arch friendly java home - will update with archlinx-java
[ -d /usr/lib/jvm/default ] && export JAVA_HOME=/usr/lib/jvm/default
