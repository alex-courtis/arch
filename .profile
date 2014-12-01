if [ ${0} == "-bash" ]; then

	# bash completion provided by brew
	if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
		. /usr/local/etc/profile.d/bash_completion.sh
	fi
	HISTSIZE=10000
fi

if [ -f ~/.bashrc ]; then
	if [ ${0} == "-bash" ]; then
		. ~/.bashrc
	elif [ ${0} == "-ksh" ]; then
		export ENV=~/.bashrc
	fi
fi

# no OS X dotfiles
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
export COPYFILE_DISABLE=true

# atlassian scripts
if [ -d ~/src/git-scripts ]; then
	alias git-merge-poms='git mergetool --tool=versions -y'
fi
if [ -d ~/src/robbieg.bin ]; then
	export PATH=~/src/robbieg.bin:${PATH}
fi
if [ -d ~/src/atlassian-scripts ]; then
	export PATH=~/src/atlassian-scripts/bin:${PATH}
	export ATLASSIAN_SCRIPTS=~/src/atlassian-scripts
fi

if [ "$(type -t jdk8)" == "function" ]; then
	jdk8
fi
