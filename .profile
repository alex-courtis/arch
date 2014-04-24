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

export MAVEN_OPTS='-Xmx768m -XX:MaxPermSize=384m'

if [ -x /usr/libexec/java_home ]; then
	/usr/libexec/java_home > /dev/null 2>&1
	if [ ${?} -eq 0 ]; then
		export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
		export PATH=${JAVA_HOME}/bin:${PATH}
	fi
fi

if [ -d /opt/jdk1.7.0 ]; then
	export JAVA_HOME=/opt/jdk1.7.0
	export PATH=${JAVA_HOME}/bin:${PATH}
fi
if [ -d /opt/java/sdk/jdk1.7.0_40 ]; then
	export JAVA_HOME=/opt/java/sdk/jdk1.7.0_40
	export PATH=${JAVA_HOME}/bin:${PATH}
fi
