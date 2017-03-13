#!/bin/sh

if [ -d /opt/alex/bin ]; then
	PATH=/opt/alex/bin:${PATH}
fi

if [ -d ~/bin ]; then
	PATH=~/bin:${PATH}
fi

export PATH
