# runs trayer in the background
if [ -f /usr/bin/trayer ]; then

    # kill if running
    pkill trayer

    # run minimised top right
    /usr/bin/trayer --edge top --align right --widthtype request --heighttype request --transparent true --alpha 0 --tint 0x333333 --monitor 0 &
fi
