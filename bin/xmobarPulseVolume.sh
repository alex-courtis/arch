#!/bin/bash

# passes up, down, mute, mute-input to pulseaudio-ctl
# unmutes instead of up or down, if muted
# outputs status to named pipe ${XDG_RUNTIME_DIR}/xmobarPulseVolume, for display by xmobar
# attempts to start ${PA_USER_SERVICE} once in a blocking manner, if ${PA_CTL} can't get a reasonable response

PA_CTL="pulseaudio-ctl"
PA_USER_SERVICE="pulseaudio.service"
PA_FAIL_MESSAGE="No PulseAudio daemon running"

# only the first argument is noteworthy
[[ ${#} -eq 1 ]] && ACTION="${1}"

# just give up if we don't have the needful
[[ ! $(type -t "${PA_CTL}") ]] && exit 1

# setup a named pipe
PIPE=${XDG_RUNTIME_DIR}/xmobarPulseVolume
[[ -p "${PIPE}" ]] || mkfifo "${PIPE}"

# retrieve status from pulse audio
PA_FULL_STATUS=$(${PA_CTL} full-status 2>&1)

# attempt to start service on fail response - return codes are borken for ${PA_CTL}
if [[ "${PA_FULL_STATUS}" =~ "${PA_FAIL_MESSAGE}" ]]; then

    # attempt to start
    systemctl --user start ${PA_USER_SERVICE}

    # try again but fail hard if the service didn't start
    PA_FULL_STATUS=$(${PA_CTL} full-status 2>&1)
    if [[ "${PA_FULL_STATUS}" =~ "${PA_FAIL_MESSAGE}" ]]; then
        exit 1
    fi
fi

# existing status
PA_STATUS=(${PA_FULL_STATUS})

# unmute if changing volume and we are muted
if [[ "${PA_STATUS[1]}" == "yes" && ( "${ACTION}" == "up" || "${ACTION}" == "down" ) ]]; then
    ACTION="mute"
fi

# enact only known actions and update status
case ${ACTION} in
"up") ;&
"down") ;&
"mute") ;&
"mute-input")
    # enact
    "${PA_CTL}" "${ACTION}"

    # update status
    PA_STATUS=($(${PA_CTL} full-status 2>&1))
;;
esac

# format output for xmobar
OUTPUT="Vo"
if [[ "${PA_STATUS[1]}" == "no" ]]; then
    # output on at %
    OUTPUT+=" ${PA_STATUS[0]}%"
else
    # output off
    OUTPUT+=" Off"
fi
if [[ "${PA_STATUS[2]}" == "no" ]]; then
    # input on
    OUTPUT+="   <fc=red>Vi On</fc>"
fi

# write to the pipe
echo "${OUTPUT}" > ${PIPE}
