#!/bin/sh

# rcup just cannot handle dotted files

ln -s \
	"${HOME}/.dotfiles/local/share/nvim/site/pack/packer/start/.luarc.json" \
	"${HOME}/.local/share/nvim/site/pack/packer/start/.luarc.json"
