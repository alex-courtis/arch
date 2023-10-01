#!/bin/zsh

# runs in ~/.dotfiles/hooks/post-up

# all base16 colours
base16sed=""
for k v in "${(@kv)BASE16}"; do
	base16sed="${base16sed} s/\$BASE16\[${k}\]/${v}/g ;"
done
base16sed="${base16sed}"

for f in ${(ps: :)APPEARANCE_FILES}; do
	src="../../${f}"
	dst="${HOME}/.${f}"
	tmp="/tmp/$(basename ${f})"

	cp "${src}" ${tmp} 

	# base16
	sed -i -e "${base16sed}" "${tmp}"

	# font
	sed -i -e "s/\$FONT_SIZE_PT/${FONT_SIZE_PT}/g" "${tmp}"

	# prompt colour
	sed -i -e "s/\$PROMPT_COL_NAME/${PROMPT_COL_NAME}/g" "${tmp}"
	sed -i -e "s/\$PROMPT_COL_RGB/${PROMPT_COL_RGB}/g" "${tmp}"

	diff "${tmp}" "${dst}" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		mv -v "${tmp}" "${dst}"
	else
		rm "${tmp}"
	fi
done

