#!/bin/sh

jq --slurp --compact-output \
	'.[0].brave.accelerators=.[1] |
	.[0].brave.default_accelerators=.[2] |
	.[0].extensions.commands=.[3] |
	.[0]' \
	~/.config/BraveSoftware/Brave-Browser/Default/Preferences \
	brave.accelerators.json \
	brave.default_accelerators.json \
	extensions.commands.json \
	> /home/alex/.config/BraveSoftware/Brave-Browser/Default/Preferences.ins.json
