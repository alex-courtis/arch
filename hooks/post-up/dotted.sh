#!/bin/sh

# rcup just cannot handle dotted files

ln -fs \
	"${HOME}/.dotfiles/local/share/nvim/site/pack/packer/start/.luarc.json" \
	"${HOME}/.local/share/nvim/site/pack/packer/start/.luarc.json"
