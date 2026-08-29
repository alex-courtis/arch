#!/bin/sh

way-displays > "/tmp/way-displays.${XDG_VTNR}.${USER}.$(date +%Y%m%d_%H%M%S).log" 2>&1 &
