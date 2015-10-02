#!/bin/bash

XRANDR="xrandr"
LAPTOP_ID="eDP1"
LAPTOP_DPI="144"

if [ $(${XRANDR} | grep " connected" | wc -l) -eq 1 ]; then
    if [ $(${XRANDR} | grep "${LAPTOP_ID} connected" | wc -l) -eq 1 ]; then
        echo "Xft.dpi: ${LAPTOP_DPI}" | xrdb -merge
    fi
fi
