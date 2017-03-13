#!/bin/bash

# passes up, down, mute, mute-input to pulseaudio-ctl
# unmutes instead of up, down, if muted
# outputs status to named pipe ${XDG_RUNTIME_DIR}/xmobarPulseVolume, for display by xmobar
# right click updates

PA_CTL="pulseaudio-ctl"
PA_USER_SERVICE="pulseaudio.service"
[ ! $(type -t "${PA_CTL}") ] && exit 1

# start the user service, if it's not running
systemctl --user status ${PA_USER_SERVICE} 2>&1 >/dev/null
if [ ${?} -ne 0 ]; then
    systemctl --user start ${PA_USER_SERVICE}
fi

# setup a named pipe
PIPE=${XDG_RUNTIME_DIR}/xmobarPulseVolume
[ -p "${PIPE}" ] || mkfifo "${PIPE}"

# only the first argument is noteworthy
[ ${#} -eq 1 ] && ACTION=${1}

# existing status
CUR_PA_STATUS=($(${PA_CTL} full-status))
[ "${CUR_PA_STATUS[1]}" == "yes" ] && CUR_OUT_MUTE="true"

# unmute if changing volume and we are muted
if [ "${CUR_OUT_MUTE}" ]; then
    if [ "${ACTION}" == "up" -o "${ACTION}" == "down" ]; then
        ${PA_CTL} mute
        unset ACTION
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
[ "${PA_STATUS[1]}" == "yes" ] && OUT_MUTE="true"
[ "${PA_STATUS[2]}" == "yes" ] && IN_MUTE="true"

# output for xmobar
OUTPUT="Vo"
if [ ${OUT_MUTE} ]; then
    OUTPUT+=" Off"
else
    OUTPUT+=" ${OUT_VOL}%"
fi
if [ ! ${IN_MUTE} ]; then
    OUTPUT+="   <fc=red>Vi On</fc>"
fi
OUTPUT="<action=\`~/bin/xmobarPulseVolume.sh\` button=3>${OUTPUT}</action>"

# write to the pipe
echo "${OUTPUT}" > ${PIPE}
