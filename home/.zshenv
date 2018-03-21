# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"

# case insensitive searching and colours
export LESS="IR"

# will be default soon...
export USE_NEW_JMAKE=true

# arch friendly java home - will update with archlinx-java
[ -d /usr/lib/jvm/default ] && export JAVA_HOME=/usr/lib/jvm/default

# maven defaults
export MAVEN_OPTS='-Xmx1536m'

# tell the old AWT apps that we're not using a reparenting window manager
# see: https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
export _JAVA_AWT_WM_NONREPARENTING=1
