# TODO: what's the advantage of separating .zshenv from .zshrc?
# these come before zprofile / .zprofile which is problematic

# vi everywhere, symlinked to vim
export EDITOR="vi"
export VISUAL="vi"

# better paging
export PAGER="less"
export LESS="R"

# optional git PS1 shows extra flags
# TODO: zsh has different flags
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true

# arch friendly java home - will update with archlinx-java
[ -d /usr/lib/jvm/default ] && export JAVA_HOME=/usr/lib/jvm/default

# maven defaults
export MAVEN_OPTS='-Xmx1536m'

# tell the old AWT apps that we're not using a reparenting window manager
# see: https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
#export _JAVA_AWT_WM_NONREPARENTING=1
