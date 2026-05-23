#!/bin/sh

export WAYLAND_DEBUG=1

valgrind \
	--leak-check=full \
	--show-leak-kinds=all \
	--suppressions="${HOME}/.vg.way-displays.supp" \
	way-displays \
	-L debug \
	> "${HOME}/way-displays.${XDG_VTNR}.${USER}.$(date +%Y%m%d_%H%M%S).log" \
	2>&1 &
