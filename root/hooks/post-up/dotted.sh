#!/bin/sh

# rcup just cannot handle dotted files

pwd
cp \
	"../../usr/share/nvim/runtime/.luarc.json" \
	"/usr/share/nvim/runtime"

