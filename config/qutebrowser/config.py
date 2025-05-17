config.load_autoconfig(False)

c.qt.force_platform = 'wayland'

# not optimal; maybe fixed ~20250517 https://github.com/qutebrowser/qutebrowser/issues/8535
c.qt.force_software_rendering = 'chromium'

c.colors.webpage.darkmode.enabled = True

c.url.start_pages  = ['about:blank']
c.url.default_page = 'about:blank'

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

