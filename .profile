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

# atlassian scripts
if [ -d ~/src/git-scripts ]; then
	alias gitMergePoms='git mergetool --tool=versions -y'
fi
if [ -d ~/src/atlassian-scripts ]; then
	export PATH=~/src/atlassian-scripts/bin:${PATH}
	export ATLASSIAN_SCRIPTS=~/src/atlassian-scripts
fi

if [ "$(type -t jdk8)" == "function" ]; then
	jdk8 > /dev/null
fi

if [ -d /opt/jdk1.7.0 ]; then
	export JAVA_HOME=/opt/jdk1.7.0
	export PATH=${JAVA_HOME}/bin:${PATH}
fi
if [ -d /opt/java/sdk/jdk1.7.0_60 ]; then
	export JAVA_HOME=/opt/java/sdk/jdk1.7.0_60
	export PATH=${JAVA_HOME}/bin:${PATH}
fi
