#!/bin/bash

# based on example 3a https://wiki.archlinux.org/index.php/Xrandr

XRANDR="xrandr"
OFF_CMD="${XRANDR}"
ON_CMD="${XRANDR}"
declare -A VOUTS
eval VOUTS=$(${XRANDR}|awk 'BEGIN {printf("(")} /^\S.*connected/{printf("[%s]=%s ", $1, $2)} END{printf(")")}')
declare -A POS

POS=([X]=0 [Y]=0)

find_mode() {
  echo $(${XRANDR} |grep ${1} -A1|awk '{FS="[ x]"} /^\s/{printf("WIDTH=%s\nHEIGHT=%s", $4,$5)}')
}

xrandr_params_for() {
  OFF_CMD="${OFF_CMD} --output ${1} --off"
  if [ "${2}" == 'connected' ]; then
    eval $(find_mode ${1})  #sets ${WIDTH} and ${HEIGHT}
    MODE="${WIDTH}x${HEIGHT}"
    ON_CMD="${ON_CMD} --output ${1} --mode ${MODE} --pos ${POS[X]}x${POS[Y]}"
    POS[X]=$((${POS[X]}+${WIDTH}))
    return 0
  else
    ON_CMD="${ON_CMD} --output ${1} --off"
    return 1
  fi
}

for VOUT in ${!VOUTS[*]}; do
  xrandr_params_for ${VOUT} ${VOUTS[${VOUT}]}
done

# turn everything off
echo ${OFF_CMD}
${OFF_CMD}

# turn everything back on in the discovered order
echo ${ON_CMD}
${ON_CMD}
