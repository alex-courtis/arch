#!/bin/sh

jq '.brave.accelerators' ~/.config/BraveSoftware/Brave-Browser/Default/Preferences > brave.accelerators.json

jq '.brave.default_accelerators' ~/.config/BraveSoftware/Brave-Browser/Default/Preferences > brave.default_accelerators.json

jq '.extensions.commands' ~/.config/BraveSoftware/Brave-Browser/Default/Preferences > extensions.commands.json

