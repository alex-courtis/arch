if [ -f ~/.bashrc ]; then
	if [ ${0} == "-bash" ]; then
		. ~/.bashrc
	elif [ ${0} == "-ksh" ]; then
		export ENV=~/.bashrc
	fi
fi

# TextMate over ssh
export RMATE_HOST=auto

#=== Agent Charlie Environment ===
if [ -f ~/atlassian/env/environment ]; then
	. ~/atlassian/env/environment
fi

# freebsd-tips
if [ -x /usr/games/fortune ]; then
	/usr/games/fortune freebsd-tips
fi
