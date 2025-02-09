#!/bin/sh

# add to ${XDG_CONFIG_HOME}/hypr/hyprland.conf
# exec-once = ${HOME}/.config/hypr/start-way-displays.sh

sleep 1 # give Hyprland a moment to set its defaults

# used for ehx alias
echo ${HYPRLAND_INSTANCE_SIGNATURE} > /tmp/hyp.sig

way-displays > "/tmp/way-displays.${XDG_VTNR}.${USER}.log" 2>&1

