#!/bin/sh

# rcup just cannot handle dotted files

mkdir -p "${HOME}/.local/share/nvim/site/pack/packer/start"

ln -fs \
	"${HOME}/.dotfiles/local/share/nvim/site/pack/packer/start/.luarc.json" \
	"${HOME}/.local/share/nvim/site/pack/packer/start/.luarc.json"
