# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# local vars
os=$(uname)
hostName=$(hostname)


# user's bin in path
if [ -d ~/bin ]; then
	export PATH=~/bin:${PATH}
fi


# sensible editor defaults
set -o vi
export EDITOR="vi"
export VISUAL="vi"
export PAGER="less"


# aliases
if [ ${os} == "Darwin" -o ${os} == "FreeBSD" ]; then
	lsArgs="-G"
elif [ ${os} == "Linux" ]; then
	lsArgs="--color"
else
	lsArgs="-F"
fi

alias ls="ls ${lsArgs}"
alias ll="ls -lh"
alias lla="ll -a"
alias grep="grep -E --color"
alias rgrep="find . -type f -print0 | xargs -0 ${grepCmd}"
alias yaourt="yaourt --aur --noconfirm"

unset lsArgs


# determine known host and prompt colour for it
# 30 black
# 90 grey
# 31, 91 red
# 32, 92 green
# 33, 93 yellow
# 34, 94 blue
# 35, 95 magenta
# 36, 96 cyan
# 37 white
case "${hostName}" in
emperor*)
	promptColour=92
	;;
duke*)
	promptColour=93
	;;
gigantor*)
	promptColour=94
	;;
prince*)
	promptColour=96
	;;
*)
        promptColour=95
        ;;
esac

if [ ${USER} == "root" ]; then
	promptColour=91
fi


# scp friendly prompt
unset PROMPT_COMMAND
export PROMPT_COMMAND

if [ "$(type -t __git_ps1)" == "function" ]; then
	promptGit="\$(__git_ps1)"
fi

export PS1="
[${promptColour};1m]0;\${PWD}\D{%d/%m/%Y %H:%M:%S}\${JDK_VER}${promptGit}
\${USER}@${hostName}:\${PWD}[0m
"

unset promptGit


# no OS X dotfiles in tars
if [ ${os} == "Darwin" ]; then
	export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
	export COPYFILE_DISABLE=true
fi


# assorted scripts
if [ -d ~/src/git-scripts ]; then
	alias git-merge-poms='git mergetool --tool=versions -y'
fi
if [ -d ~/src/robbieg.bin ]; then
	export PATH=~/src/robbieg.bin:${PATH}
fi
if [ -d ~/src/mftools ]; then
	export PATH=~/src/mftools:${PATH}
fi
if [ -d ~/src/atlassian-scripts ]; then
	export PATH=~/src/atlassian-scripts/bin:${PATH}
	export ATLASSIAN_SCRIPTS=~/src/atlassian-scripts
fi
if [ -d ~/Library/Haskell/bin ]; then
	export PATH=~/Library/Haskell/bin:${PATH}
fi
if [ -d /opt/atlassian-plugin-sdk ]; then
	export PATH=/opt/atlassian-plugin-sdk/bin:${PATH}
fi

# bash completions
if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
	. /usr/local/etc/profile.d/bash_completion.sh
fi
if [ -f ~/src/maven-bash-completion/bash_completion.bash ]; then
	. ~/src/maven-bash-completion/bash_completion.bash
fi
if [ -f ~/.jmake/completion/jmake.completion.bash ]; then
	. ~/.jmake/completion/jmake.completion.bash
fi


# java home selector
latestJavaHome() {
	local roots="
		/Library/Java/JavaVirtualMachines
		/System/Library/Java/JavaVirtualMachines
		/opt/java/sdk
		/usr/lib/jvm
	"

	if [[ ${#} -ne 1 ]]; then
		printf "Usage: ${FUNCNAME} <version e.g. 1.7>\n" 1>&2
		return 1
	fi

	local root home
	for root in ${roots}; do
		if [[ -d "${root}" ]]; then
			for home in $(\ls "${root}" | sort -r); do
				if [[ -d "${root}/${home}" && "${home}" =~ "${1}" ]]; then
					if [[ -d "${root}/${home}/bin" ]]; then
						printf "${root}/${home}"
						return 0
					elif [[ -d "${root}/${home}/Contents/Home/bin" ]]; then
						printf "${root}/${home}/Contents/Home"
						return 0
					fi
				fi
			done
		fi
	done

	printf "unable to find java home with version like '${1}' in ${roots}" 1>&2
	return 1
}

jdk() {
	local newJavaHome
	newJavaHome=$(latestJavaHome ${1})
	if [[ ${?} -eq 0 ]]; then
		if [[ -n "${JAVA_HOME}" && "${PATH}" =~ "${JAVA_HOME}/bin:" ]]; then
			export PATH=${PATH/${JAVA_HOME}\/bin:/}
		fi
		export JAVA_HOME=${newJavaHome}
		export PATH=${JAVA_HOME}/bin:${PATH}
		export JDK_VER=" [$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')]"
		export MAVEN_OPTS='-Xmx1024m -XX:MaxPermSize=384m'
	fi
}

jdk6() {
	jdk 6
}

jdk7() {
	jdk 7
}

jdk8() {
	jdk 8
	export MAVEN_OPTS='-Xmx1024m'
}

jdk8



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


# clear local vars
unset os
unset hostName
unset promptColour
