#!/bin/sh

cp "${HOME}/.config/BraveSoftware/Brave-Browser/Default/Preferences" "${HOME}/.config/BraveSoftware/Brave-Browser/Default/Preferences.$(date +%Y%m%d_%H%M%S)"

jq --slurp --compact-output \
	'.[0].brave.accelerators=.[1] |
	.[0].brave.default_accelerators=.[2] |
	.[0].extensions.commands=.[3] |
	.[0]' \
	"${HOME}/.config/BraveSoftware/Brave-Browser/Default/Preferences" \
	brave.accelerators.json \
	brave.default_accelerators.json \
	extensions.commands.json \
	> "${HOME}/.config/BraveSoftware/Brave-Browser/Default/Preferences.json"

mv "${HOME}/.config/BraveSoftware/Brave-Browser/Default/Preferences.json" "${HOME}/.config/BraveSoftware/Brave-Browser/Default/Preferences"
