#!/bin/zsh

# runs in ~/.dotfiles/hooks/post-up

for f in ${(ps: :)APPEARANCE_FILES}; do
	src="../../${f}"
	dst="${HOME}/.${f}"
	tmp="/tmp/$(basename ${f})"

	cp "${src}" ${tmp} 

	# all base16 colours
	for k v in "${(@kv)BASE16}"; do
		# TODO one sed
		sed -i -e "s/\$BASE16\[${k}\]/${v}/g" "${tmp}"
	done

	# font
	sed -i -e "s/\$FONT_SIZE_PT/${FONT_SIZE_PT}/g" "${tmp}"

	# host colour
	sed -i -e "s/\$HL_BG/${HL_BG}/g" "${tmp}"
	sed -i -e "s/\$HL_FG/${HL_FG}/g" "${tmp}"

	diff "${tmp}" "${dst}" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		mv -v "${tmp}" "${dst}"
	else
		rm "${tmp}"
	fi
done

