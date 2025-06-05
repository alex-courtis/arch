#!/bin/sh

for f in ".zprofile" ".zshrc"; do
	if [ -L "${HOME}/${f}.host" ]; then
		echo "catting ${f} ${f}.host"

		cat "${HOME}/${f}" "${HOME}/${f}.host" > "${HOME}/${f}.complete"
		rm "${HOME}/${f}" "${HOME}/${f}.host"
		mv "${HOME}/${f}.complete" "${HOME}/${f}"
	fi
done

