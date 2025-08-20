#!/bin/zsh

theme="catppuccin-vimium-mocha.css"

base16sed=""
for k v in "${(@kv)BASE16}"; do
	base16sed="${base16sed} s/\$BASE16\[${k}\]/${v}/g ;"
done
base16sed="${base16sed}"

# indent 2 for yaml
cat "${theme}" | sed -e 's/^/  /g' > /tmp/ss.indented.css

# substitue colours
sed -i -e "${base16sed}" /tmp/ss.indented.css

# insert the stylesheet and output as json
cat vimium-options.yaml | sed -e '/STYLESHEET/{r /tmp/ss.indented.css
d }' | yq -oj > vimium-options.json
