#!/bin/bash

# links all files in SYSTEM directories of ALEX to their equivalents on the file system
# must be run as root
SYSTEM="etc"
ALEX=/opt/alex

cd ${ALEX}
for f in $(find ${SYSTEM} -type f); do 
    ln -fsv ${ALEX}/${f} /$(dirname ${f})
done
