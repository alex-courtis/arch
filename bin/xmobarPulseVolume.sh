#!/bin/bash

# passes up, down, mute, mute-input to pulseaudio-ctl
# unmutes prior to up, down
# outputs status to named pipe ${XDG_RUNTIME_DIR}/xmobarPulseVolume, for display by xmobar or similar

PA_CTL="/usr/bin/pulseaudio-ctl"
[ ! -f ${PA_CTL} ] && exit 1

# setup a named pipe
PIPE=${XDG_RUNTIME_DIR}/xmobarPulseVolume
[ -p "${PIPE}" ] || mkfifo "${PIPE}"

# only the first argument is noteworthy
[ ${#} -eq 1 ] && ACTION=${1}

# existing status
CUR_PA_STATUS=($(${PA_CTL} full-status))
[ ${CUR_PA_STATUS[1]} == "yes" ] && CUR_OUT_MUTE="true"

# unmute if changing volume and we are muted
if [ ${CUR_OUT_MUTE} ]; then
    if [ "${ACTION}" == "up" -o "${ACTION}" == "down" ]; then
        echo "turning on Vo"
        ${PA_CTL} mute
    fi
fi

# enact known actions
case ${ACTION} in
    "up") ;&
    "down") ;&
    "mute") ;&
    "mute-input")
        ${PA_CTL} ${ACTION} ;;
esac

# new status
PA_STATUS=($(${PA_CTL}  full-status))
OUT_VOL=${PA_STATUS[0]}
[ ${PA_STATUS[1]} == "yes" ] && OUT_MUTE="true"
[ ${PA_STATUS[2]} == "yes" ] && IN_MUTE="true"

# output for xmobar
OUTPUT="Vo"
if [ ${OUT_MUTE} ]; then
    OUTPUT+=" off"
else
    OUTPUT+=" ${OUT_VOL}%"
fi
OUTPUT+=" Vi"
if [ ${IN_MUTE} ]; then
    OUTPUT+=" off"
else
    OUTPUT+=" on"
fi
echo "${OUTPUT}" > ${PIPE}
