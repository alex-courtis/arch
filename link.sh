#!/bin/bash

# links all files in home directory to their appropriate place under user HOME
# must be run as user from this directory
ALEX_HOME="$(pwd)/home"

for f in $(find "${ALEX_HOME}" -type f); do
    TARGET="${f/${ALEX_HOME}/${HOME}}"
    TARGET_DIR=$(dirname "${TARGET}")
    if [ ! -d ${TARGET_DIR} ]; then
        mkdir -pv "${TARGET_DIR}"
    fi
    ln -fsv "${f}" "${TARGET}"
done
