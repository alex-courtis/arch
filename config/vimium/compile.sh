#!/bin/sh

# https://github.com/zfhg/vimium-dark-theme

# indent 2 for yaml
cat vimium-dark-theme.css | sed -e 's/^/  /g' > /tmp/ss.indented.css

# insert the stylesheet and output as json
cat vimium-options.yaml | sed -e '/STYLESHEET/{r /tmp/ss.indented.css
d }' | yq -oj > vimium-options.json
