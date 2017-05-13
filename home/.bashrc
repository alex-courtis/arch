# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# local vars
os=$(uname)
hostName=$(hostname)

# more history
HISTSIZE=10000
HISTFILESIZE=10000

# editor/pager defaults
set -o vi
export EDITOR="vi"
export VISUAL="vi"
export PAGER="less"
export LESS="R"

# aliases
if [ "${os}" == "Darwin" -o "${os}" == "FreeBSD" ]; then
    alias ls="ls -G"
elif [ "${os}" == "Linux" ]; then
    alias ls="ls --color"
else
    alias ls="ls -F"
fi
alias ll="ls -lh"
alias lla="ll -a"
alias grep="grep -E --color"
alias rgrep="find . -type f -print0 | xargs -0 grep"
alias yaourt="yaourt --aur --noconfirm"
if [ -d ~/src/git-scripts ]; then
    alias git-merge-poms='git mergetool --tool=versions -y'
fi

# assorted tools to add to PATH
[ -d ~/src/robbieg.bin ] && export PATH=~/src/robbieg.bin:${PATH}
[ -d ~/src/atlassian-scripts ] && export PATH=~/src/atlassian-scripts/bin:${PATH}
[ -d ~/src/monorepo_utils ] && export PATH=~/src/monorepo_utils:${PATH}

# bash completions
[ $(type -t /usr/share/git/completion/git-prompt.sh) ] && /usr/share/git/completion/git-prompt.sh
[ $(type -t ~/src/maven-bash-completion/bash_completion.bash) ] && . ~/src/maven-bash-completion/bash_completion.bash
[ $(type -t ~/.jmake/completion/jmake.completion.bash) ] && . ~/.jmake/completion/jmake.completion.bash
[ $(type -t pio) ] && eval "$(_PIO_COMPLETE=source pio)"

# optional git PS1 shows extra flags
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true

# prompt ":;"
#   "\e"    escape sequence start
#   "\["    nonprinting sequence start
#   "\]"    nonprinting sequence end
#   "[4xm"  background colour where x==colour:
#       0 black  1 red       2 green 3 yellow
#       4 blue   5 magenta   6 cyan  7 white
#   "[0m"   resets all colours to whatever we had before
case "${hostName}" in
emperor*)
    promptColour="[42m"
    ;;
duke*)
    promptColour="[46m"
    ;;
gigantor*)
    promptColour="[44m"
    ;;
* )
    promptColour="[45m"
    ;;
esac
PS1="\[\e${promptColour}\]:;\[\e[0m\] "

# pre prompt
#   "]2;"   ESC xterm (title) code
#   "\a"    BEL xterm (title) code
__prompt_command() {

    # print non-zero exit code in red, on its own line
    local rc=$?
    [ $rc -ne 0 ] && printf "\e[41m%s\e[0m\n" ${rc}

    # print current directory to title
    printf "\e]2;%s" "${PWD}"
    
    # optionally print git status
    [ "$(type -t __git_ps1)" == "function" ] && printf "%s" "$(__git_ps1)"

    # end title
    printf "\a"
}
PROMPT_COMMAND=__prompt_command

# arch friendly java home - will update with archlinx-java
[ -d /usr/lib/jvm/default ] && export JAVA_HOME=/usr/lib/jvm/default

# maven defaults
export MAVEN_OPTS='-Xmx1536m'

# user mount helpers
if [ $(type -t udisksctl) ]; then
    mnt() {
        if [ ${#} -ne 1 ]; then
            echo "Usage: ${FUNCNAME} <block device>" >&2
            return 1
        fi
        udisksctl mount -b ${1} && cd $(findmnt -n -o TARGET ${1})
    }
    umnt() {
        if [ ${#} -ne 1 ]; then
            echo "Usage: ${FUNCNAME} <block device>" >&2
            return 1
        fi
        udisksctl unmount -b ${1}
    }
fi

# rsync scripts
if [ ${hostName} == "EMPEROR" ]; then

	# perform an rsync with OSXish options
	doRsync() {
		if [[ ${#} -lt 2 ]]; then
			printf "Usage: ${FUNCNAME} <SRC> <DST> [<rsync args>]...\n" 1>&2
		else
			local src="${1}"
			local dst="${2}"
			shift; shift
			
			# check that src exists or is remote
			printf "%s" "${src}" | grep \: > /dev/null 2>&1
			if [[ ${?} -ne 0 && ! -d "${src}" ]]; then
				printf "${src} does not exist\n" 1>&2
				return 1
			fi
			
			# check that dst exists or is remote
			printf "%s" "${dst}" | grep \: > /dev/null 2>&1
			if [[ ${?} -ne 0 && ! -d "${dst}" ]]; then
				printf "${dst} does not exist\n" 1>&2
				return 1
			fi
			
			rsync --recursive --delete --verbose --progress --times --omit-dir-times ${*} "${src}" "${dst}"
		fi
	}
	
	# rsync aliases
	alias syncMusicEarl="doRsync /mnt/c/Users/alex/Music/iTunes/iTunes\ Media/Music/ earl:/mnt/vol1/music --exclude=\"desktop.ini\""
	#alias syncMusicGigantor="doRsync ~/Music/iTunes/ acourtis@gigantor:Music/iTunes"
	#alias syncMusicPrince="doRsync ~/Music/iTunes/ prince:Music/iTunes"
	#alias syncMusicMarquis="doRsync ~/Music/iTunes/ marquis:Music/iTunes"
	#alias syncPicturesEarl="doRsync ~/Pictures/ earl:/mnt/vol1/media/pictures --exclude=\"*Cache\""
	#alias syncFlacEarl="doRsync /Volumes/Data/flac/ earl:/mnt/vol1/media/flac"
fi

# user bin at start of path
[ -d ~/bin ] && export PATH=~/bin:${PATH}

# clear local vars
unset promptColour
unset os
unset hostName
