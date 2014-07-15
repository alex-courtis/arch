# local vars
os=$(uname)
hostName=$(hostname -f)

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
if [ ${hostName%%.*} == "emperor" ]; then
	promptColour=92
elif [ ${hostName%%.*} == "gigantor" ]; then
	promptColour=93
elif [ ${hostName%%.*} == "marquis" ]; then
	promptColour=96
else
	promptColour=95
fi

# root has a red prompt on any host
if [ ${USER} ]; then
	if [ ${USER} == "root" ]; then
		promptColour=91
	fi
elif [ ${LOGNAME} ]; then
	if [ ${LOGNAME} == "root" ]; then
		promptColour=91
	fi
fi

# determine the username prompt
if [ ${USER} ]; then
	promptUserName=\${USER}@
elif [ ${LOGNAME} ]; then
	promptUserName=\${LOGNAME}@
fi

# scp compatible prompt
if [ ${BASH} ]; then
	unset PROMPT_COMMAND
	export PROMPT_COMMAND
	promptDateStatus="\D{%d/%m/%Y %H:%M:%S}"

	if [ "$(type -t asdf__git_ps1)" == "function" ]; then
		promptDateStatus="${promptDateStatus}\$(__git_ps1)"
	fi
fi
promptTitle="]0;\${PWD}"
export PS1="
[${promptColour};1m${promptTitle}${promptDateStatus}
${promptUserName}${hostName}:\${PWD}[0m
"

# aliases
if [ ${os} == "Darwin" -o ${os} == "FreeBSD" ]; then
	lsArgs="-G"
elif [ ${os} == "Linux" ]; then
	lsArgs="--color"
else
	lsArgs="-F"
fi
if [ ${os} == "Darwin" -o ${os} == "FreeBSD" -o ${os} == "Linux" ]; then
	grepCmd="grep -E --color"
else
	grepCmd="grep"
fi
alias ls="ls ${lsArgs}"
alias ll="ls -lah"
alias grep="${grepCmd}"
alias rgrep="find . -type f -print0 | xargs -0 ${grepCmd}"

# always use vi for command line editing
set -o vi
export EDITOR=vi

# user's bin
if [ -d ~/bin ]; then
	export PATH=~/bin:${PATH}
fi

if [ ${BASH} ]; then

	# change dodgey permissions
	chmodDir() {
		if [[ ${#} -ne 1 || ! -d "${1}" ]]; then
			printf "Usage: ${FUNCNAME} <directory to securely chmod: 755 for dir or shell script; 644 for other>\n" 1>&2
		else
			printf "\n\nDirectories: 755\n"
			find "${1}" -type d -print -exec chmod 755 {} \;
			printf "\n\nFiles 644\n"
			find "${1}" -type f -not -iname "*sh" -print -exec chmod 644 {} \;
			printf "\n\nExecutable Files 755\n"
			find "${1}" -type f -iname "*sh" -print -exec chmod 755 {} \;
		fi
	}

	# rename all contents
	renameAll() {
		if [[ ${#} -ne 3 || ! -d "${1}" ]]; then
			printf "Usage: ${FUNCNAME} <directory to search> <search string> <replace string>\n" 1>&2
		else
			export findPattern=${2}
			export replacePattern=${3}
			find "${1}" -type f -execdir bash -c '
				fromName=${1}
				toName=${1/${findPattern}/${replacePattern}}
				echo "${fromName} -> ${toName}"
				mv "${fromName}" "${toName}"
			' _ {} \;
			unset findPattern
			unset replacePattern
		fi
	}

	# rename all files by date in the directory specified
	renameByDate() {
		if [[ ${#} -ne 1 || ! -d "${1}" ]]; then
			printf "Usage: ${FUNCNAME} <directory to add content file name prefix of: <number starting from 10000>_>\n" 1>&2
		else
			i=10000
			cd "${1}"
			orgifs=$IFS
			IFS=$'\n'
			for f in $(ls -tr); do
				if [ -f "${f}" ]; then
					printf "%s -> %s\n" ${f} "${i}_${f}"
					mv "${f}" "${i}_${f}"
					let i=i+1
				fi
			done
			unset i
			IFS=$orgifs
			unset orgifs
			cd - > /dev/null 2>&1
		unset f
		fi
	}

	# undo the effects of renameByDate in the directory specified
	undoRenameByDate() {
		if [[ ${#} -ne 1 || ! -d "${1}" ]]; then
			printf "Usage: ${FUNCNAME} <directory to remove content file name prefix of: <number starting from 10000>_>\n" 1>&2
		else
			cd "${1}"
			orgifs=$IFS
			IFS=$'\n'
			for f in $(ls | grep "^[0-9]{5}_"); do
				if [ -f "${f}" ]; then
					printf "%s -> %s\n" "${f}" "${f#*_}"
					mv "${f}" "${f#*_}"
				fi
			done
			unset f
			IFS=$orgifs
			unset orgifs
			cd - > /dev/null 2>&1
		fi
	}

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
				return -1
			fi
			
			# check that dst exists or is remote
			printf "%s" "${dst}" | grep \: > /dev/null 2>&1
			if [[ ${?} -ne 0 && ! -d "${dst}" ]]; then
				printf "${dst} does not exist\n" 1>&2
				return -1
			fi
			
			rsync --recursive --delete --verbose --progress --times --omit-dir-times ${*} "${src}" "${dst}"
		fi
	}
fi

# OS X java environment setup
if [ -x /usr/libexec/java_home ]; then
	
	jdk6() {
		export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
		export PATH=${JAVA_HOME}/bin:${PATH}
		export MAVEN_OPTS='-Xmx768m -XX:MaxPermSize=384m'
		echo ${JAVA_HOME}
	}
	
	jdk7() {
		export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
		export PATH=${JAVA_HOME}/bin:${PATH}
		export MAVEN_OPTS='-Xmx768m -XX:MaxPermSize=384m'
		echo ${JAVA_HOME}
	}
	
	jdk8() {
		export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
		export PATH=${JAVA_HOME}/bin:${PATH}
		export MAVEN_OPTS='-Xmx768m'
		echo ${JAVA_HOME}
	}
fi

if [ ${hostName%%.*} == "prince" ]; then
	
	# rsync aliases
	alias syncMusicEmperor="doRsync ~/Music/iTunes/ emperor:Music/iTunes"
	
elif [ ${hostName%%.*} == "emperor" ]; then
	
	# rsync aliases
	alias syncMusicSerf="doRsync ~/Music/iTunes/iTunes\ Media/Music/ serf:/volume1/Music"
	alias syncMusicGigantor="doRsync ~/Music/iTunes/ acourtis@gigantor:Music/iTunes"
	alias syncMusicPrince="doRsync ~/Music/iTunes/ prince:Music/iTunes"
	alias syncMusicMarquis="doRsync ~/Music/iTunes/ marquis:Music/iTunes"
	alias syncPicturesSerf="doRsync ~/Pictures/ serf:/volume1/Pictures --exclude=\"*Cache\""
	alias syncFlacSerf="doRsync /Volumes/Data/flac/ serf:/volume1/Media/flac"
	alias syncMusicKing="doRsync ~/Music/iTunes/iTunes\ Media/Music/ king:/sdcard/Music --no-times --size-only --exclude=\"*pamp\""
	
	# repack an avi with mencode
	remuxAvi() {
		if [[ ${#} -ne 1 || ! -f "${1}" ]]; then
			printf "Usage: ${FUNCNAME} <avi file>\n" 1>&2
		else
			mencoder -quiet -ovc copy -oac copy -of avi -o remuxed.avi "${1}" && touch -r "${1}" remuxed.avi && mv remuxed.avi "${1}"
		fi
	}
	
	# create an iso image of a DVD directory
	mkDvdIso() {
		if [[ ${#} -ne 1 || ! -d "${1}" ]]; then
			printf "Usage: ${FUNCNAME} <directory containing AUDIO_TS and VIDEO_TS>\n" 1>&2
		else
			cd "${1}"/..
			local isoName=$(basename "${1}")
			mkisofs -dvd-video -o "${isoName}.iso" -V "${isoName}" "${isoName}"
			cd - > /dev/null 2>&1
		fi
	}
	
	# identify immediate subdirectories of /Volumes/Data/flac which do not exist under ~/Music/iTunes/iTunes\ Media/Music with the iTunes escape characters applied
	missingAudioCDs() {
		orgifs=$IFS
		IFS=$'\n'
		for d in $(ls "/Volumes/Data/flac/FLAC (level 5)"); do
			iTunesName=${d}
			iTunesName=${iTunesName/\?/_}
			iTunesName=${iTunesName/\:/_}
			iTunesName=${iTunesName/\(/\\\(}
			iTunesName=${iTunesName/\)/\\\)}
			find ~/Music/iTunes/iTunes\ Media/Music -type d -name "${iTunesName}" | grep "${iTunesName}" > /dev/null 2>&1
			if [[ ${?} -ne 0 ]]; then
				printf "%s\n" ${d}
			fi
		done
		IFS=$orgifsz	
		unset orgifs
	}
fi

# clear vars
unset os
unset hostName
unset promptColour
unset promptTitle
unset promptDate
unset promptUserName
unset grepCmd
unset lsArgs
