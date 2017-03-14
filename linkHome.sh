#!/bin/bash

# links all files in home directory to their appropriate place under user HOME
# must be run as user from this directory
ALEX_HOME=$(pwd)/home

for f in $(find ${ALEX_HOME} -type f); do
    ln -fsv ${f} ${f/${ALEX_HOME}/${HOME}}
done
