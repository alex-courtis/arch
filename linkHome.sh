#!/bin/bash

# links all files in ALEX_HOME directory to their equivalents on the file system relative to user home
# must be run as root
ALEX_HOME=/opt/alex/home

cd ${ALEX_HOME}
for f in $(find . -type f); do 
    ln -fsv ${ALEX_HOME}/${f} ${HOME}/$(dirname ${f})
done
