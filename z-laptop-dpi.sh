#!/bin/bash

XRANDR="xrandr"
XRDB="xrdb"
LAPTOP_ID="eDP1"
LAPTOP_DPI="168"
DEFAULT_DPI="96"

DESIRED_DPI=${DEFAULT_DPI}
if [ $(${XRANDR} | grep " connected" | wc -l) -eq 1 ]; then
    if [ $(${XRANDR} | grep "${LAPTOP_ID} connected" | wc -l) -eq 1 ]; then
        DESIRED_DPI=${LAPTOP_DPI}
    fi
fi

echo "Xft.dpi: ${DESIRED_DPI}" | ${XRDB} -merge
