#!/bin/bash

# links all files in SYSTEM directories to their appropriate place under the filesystem root
# must be run as root from this directory
SYSTEM="etc usr"
ALEX_ROOT=$(pwd)

for f in $(find ${SYSTEM} -type f -or -type l); do 
    ln -fsv ${ALEX_ROOT}/${f} /${f}
done
