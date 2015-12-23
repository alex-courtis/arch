#!/bin/bash

# based on example 3a https://wiki.archlinux.org/index.php/Xrandr

XRANDR="xrandr"
LAPTOP_ID="eDP1"
LAPTOP_OFF=false
OFF_ARGS=""
ON_ARGS=""
PRIMARY="--primary"
declare -A VOUTS
eval VOUTS=$(${XRANDR}|awk 'BEGIN {printf("(")} /^\S.*connected/{printf("[%s]=%s ", $1, $2)} END{printf(")")}')
declare -A POS

POS=([X]=0 [Y]=0)

find_mode() {
  echo $(${XRANDR} |grep ${1} -A1|awk '{FS="[ x]"} /^\s/{printf("WIDTH=%s\nHEIGHT=%s", $4,$5)}')
}

xrandr_params_for() {
  if [ "${2}" == 'connected' ]; then
    eval $(find_mode ${1})  #sets ${WIDTH} and ${HEIGHT}
    MODE="${WIDTH}x${HEIGHT}"
    ON_ARGS="${ON_ARGS} --output ${1} --mode ${MODE} --pos ${POS[X]}x${POS[Y]} ${PRIMARY}"
    PRIMARY=""
    POS[X]=$((${POS[X]}+${WIDTH}))
    return 0
  else
    OFF_ARGS="${OFF_ARGS} --output ${1} --off"
    return 1
  fi
}

# disconnected if the lid is closed, otherwise status returned by xrandr
laptop_status() {
  grep "closed" /proc/acpi/button/lid/LID*/state > /dev/null 2>&1
  if [ ${?} -eq 0 ]; then
    echo "disconnected"
  else
    LAPTOP_OFF=true
    echo ${VOUTS[${LAPTOP_ID}]}
  fi
}

for VOUT in ${!VOUTS[*]}; do
  if [ "${VOUT}" == "${LAPTOP_ID}" ]; then
    xrandr_params_for ${VOUT} $(laptop_status)
  else
    xrandr_params_for ${VOUT} ${VOUTS[${VOUT}]}
  fi
done

# last (right most) display is primary
#ON_ARGS="${ON_ARGS} --primary"

# cycle the laptop display (if it was on) so that it doesn't get confused
#if [ ${LAPTOP_OFF} ]; then
#  echo "${XRANDR} --output ${LAPTOP_ID} --off"
#  ${XRANDR} --output ${LAPTOP_ID} --off
#fi

# turn everything on
echo "${XRANDR} ${OFF_ARGS} ${ON_ARGS}"
${XRANDR} ${OFF_ARGS} ${ON_ARGS}
