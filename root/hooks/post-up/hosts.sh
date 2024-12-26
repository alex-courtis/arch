#!/bin/zsh

hostname="$(hostname -s)"

sed -E "s/HOSTNAME/${hostname}/g" ../../etc/hosts > /tmp/hosts

mv /tmp/hosts /etc/hosts
