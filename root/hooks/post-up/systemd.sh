#!/bin/zsh

if [ "${HOST}" = "lord" ]; then
	# not applicable for servers with big docker containers
	rm -v /etc/systemd/system.conf.d/timeout.conf
fi
