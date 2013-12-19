if [ -f ~/.bashrc ]; then
	if [ ${0} == "-bash" ]; then
		. ~/.bashrc
	elif [ ${0} == "-ksh" ]; then
		export ENV=~/.bashrc
	fi
fi

# TextMate over ssh
export RMATE_HOST=auto

if [ ${0} == "-bash" ]; then

	#=== Agent Charlie Environment ===
	if [ -f ~/atlassian/env/environment ]; then
		. ~/atlassian/env/environment
	fi

	# bash completion provided by brew
	if [ -f /usr/local/etc/bash_completion ]; then
		. /usr/local/etc/bash_completion
	fi
fi

# freebsd-tips
if [ -x /usr/games/fortune ]; then
	/usr/games/fortune freebsd-tips
fi
