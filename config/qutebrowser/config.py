config.source('base16-bright.config.min.py')

config.load_autoconfig(False)

# not optimal; maybe fixed ~20250517 https://github.com/qutebrowser/qutebrowser/issues/8535
# only appears necessary when xwayland not present
# c.qt.force_software_rendering = 'chromium'

c.auto_save.session = True

c.tabs.last_close = 'close'

c.colors.webpage.darkmode.enabled = False

c.colors.webpage.preferred_color_scheme = 'dark'

c.fonts.default_size = '13.5pt'

c.editor.command = ["alacritty", "-e", "nvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]

c.hints.chars = 'pgcrlaoeuhtnsqjkmwvz'

c.url.default_page = 'file:///.blank.html'
c.url.start_pages  = [ c.url.default_page ]

c.tabs.show = 'multiple'

c.tabs.title.format = '{audio}{private}{current_title}'
c.tabs.title.format_pinned = '{audio}{private}{current_title}'

c.tabs.padding = {"bottom": 3, "left": 0, "right": 0, "top": 2}
c.tabs.indicator.padding = {"bottom": 0, "left": 3, "right": 10, "top": 0}
c.tabs.indicator.width = 5

c.tabs.title.alignment = 'center'

c.statusbar.position = 'top'
c.statusbar.padding = {"bottom": 3, "left": 0, "right": 8, "top": 2}

c.statusbar.widgets = ["keypress", "search_match", "history", "progress", "url"]

config.unbind('q')
config.unbind('D')
config.unbind('U')

config.bind('<Escape>', 'clear-messages ;; clear-keychain ;; search ;; fullscreen --leave')

config.bind('h', 'tab-prev')
config.bind('l', 'tab-next')

config.bind('x', 'tab-close')
config.bind('X', 'tab-close -o')

config.bind('<', 'tab-move -')
config.bind('>', 'tab-move +')

config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')

config.bind('ge', 'edit-url')

config.bind('<ctrl+alt+t>', 'undo -w')

config.bind('<alt+b>', 'spawn --userscript qute-bitwarden')
config.bind('<alt+u>', 'spawn --userscript qute-bitwarden --username-only')
config.bind('<alt+p>', 'spawn --userscript qute-bitwarden --password-only')

config.bind('<alt+u>', 'spawn --userscript qute-bitwarden --username-only', mode='prompt')
config.bind('<alt+p>', 'spawn --userscript qute-bitwarden --password-only', mode='prompt')

config.bind('<alt+d>', 'set colors.webpage.darkmode.enabled true')
config.bind('<alt+l>', 'set colors.webpage.darkmode.enabled false')

config.bind('ww', 'tab-give')
