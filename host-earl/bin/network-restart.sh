#!/usr/bin/env sh

con="peerage5"

down="$(nmcli c d "${con}" 2>&1)"

echo "${down}"
notify-send "${down}"

up="$(nmcli c u "${con}" 2>&1)"

echo "${up}"
notify-send "${up}"

autofs="$(sudo systemctl start autofs 2>&1)"

echo "${autofs}"
notify-send "${autofs}"

notify-send "$(ls /lord)"
