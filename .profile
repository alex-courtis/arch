if [ -f ~/.bashrc ]; then
	if [ ${0} == "-bash" ]; then
		. ~/.bashrc
	elif [ ${0} == "-ksh" ]; then
		export ENV=~/.bashrc
	fi
fi

if [ ${0} == "-bash" ]; then

	# bash completion provided by brew
	if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
		. /usr/local/etc/profile.d/bash_completion.sh
	fi
	
	# atlassian git scripts
	if [ -d ~/src/git-scripts ]; then
		alias gitMergePoms='git mergetool --tool=versions -y'
	fi
	
	HISTSIZE=10000
fi

export MAVEN_OPTS='-Xmx768m -XX:MaxPermSize=384m'

if [ -x /usr/libexec/java_home -a $(/usr/libexec/java_home) == 0 ]; then
	export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
	export PATH=${JAVA_HOME}/bin:${PATH}
fi

# freebsd-tips
if [ -x /usr/games/fortune ]; then
	/usr/games/fortune freebsd-tips
fi
