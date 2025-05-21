config.source('base16-bright.config.min.py')

config.load_autoconfig(False)

# not optimal; maybe fixed ~20250517 https://github.com/qutebrowser/qutebrowser/issues/8535
# only appears necessary when xwayland not present
# c.qt.force_software_rendering = 'chromium'

c.auto_save.session = True

c.tabs.last_close = 'close'

c.colors.webpage.darkmode.enabled = False

c.colors.webpage.preferred_color_scheme = 'dark'

c.fonts.default_size = '13pt'

c.url.default_page = 'file:///.blank.html'
c.url.start_pages  = [ c.url.default_page ]

c.tabs.show = 'multiple'

c.colors.statusbar.private.bg = '#d381c3'
c.tabs.title.format = '{audio}{index}:{private}{current_title}'

config.unbind('q')
config.unbind('D')
config.unbind('U')

config.bind('h', 'tab-prev')
config.bind('l', 'tab-next')

config.bind('x', 'tab-close')
config.bind('X', 'tab-close -o')

config.bind('<', 'tab-move -')
config.bind('>', 'tab-move +')

config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')

config.bind('<ctrl+alt+t>', 'undo -w')

config.bind('<alt+b>', 'spawn --userscript qute-bitwarden')

config.bind('<alt+d>', 'set colors.webpage.darkmode.enabled true')
config.bind('<alt+l>', 'set colors.webpage.darkmode.enabled false')

config.bind('ww', 'tab-give')
