import os

config.source('base16-bright.py')

config.load_autoconfig(False)

# not optimal; maybe fixed ~20250517 https://github.com/qutebrowser/qutebrowser/issues/8535
# only appears necessary when xwayland not present
if not os.getenv('DISPLAY'):
	c.qt.force_software_rendering = 'chromium'

c.auto_save.session = False

c.tabs.last_close = 'close'

c.colors.webpage.darkmode.enabled = False

c.colors.webpage.preferred_color_scheme = 'dark'

c.fonts.default_size = '13.5pt'

c.editor.command = [ 'alacritty', '-e', 'nvim', '-f', '{file}', '-c', 'normal {line}G{column0}l' ]

c.hints.chars = 'pgcrlaoeuhtnsqjkmwvz'

c.url.default_page = 'file:///.blank.html'
c.url.start_pages  = [ c.url.default_page ]

c.content.pdfjs = True

c.downloads.position = 'bottom'
c.downloads.remove_finished = 5

c.tabs.show = 'multiple'

c.tabs.title.format = '{audio}{private}{current_title}'
c.tabs.title.format_pinned = '{audio}{private}{current_title}'

c.tabs.padding = {'bottom': 3, 'left': 0, 'right': 0, 'top': 3}
c.tabs.indicator.padding = {'bottom': 0, 'left': 3, 'right': 10, 'top': 0}
c.tabs.indicator.width = 5

c.tabs.title.alignment = 'center'
c.tabs.wrap = False

# many issues exist with in-mode e.g. https://github.com/qutebrowser/qutebrowser/issues/5520
c.statusbar.show = 'always'

c.statusbar.position = 'top'
c.statusbar.padding = {'bottom': 3, 'left': 0, 'right': 8, 'top': 3}

c.statusbar.widgets = ['keypress', 'search_match', 'history', 'progress', 'url']

c.content.register_protocol_handler = True

c.search.wrap = False
c.search.wrap_messages = False

c.completion.open_categories = [ 'history', 'filesystem', 'bookmarks', 'searchengines' ]

c.url.searchengines = {
		'DEFAULT': 'https://duckduckgo.com/?q={}',
		'ap':      'https://archlinux.org/packages/?q={}',
		'au':      'https://aur.archlinux.org/packages?K={}',
		'aw':      'https://wiki.archlinux.org/index.php?search={}',
		'd':       'https://duckduckgo.com/?q={}',
		'di':      'https://duckduckgo.com/?iar=images&q={}',
		'g':       'https://google.com/search?q={}',
		'gi':      'https://images.google.com/search?q={}',
		'pd':      'https://www.protondb.com/search?q={}',
		'sd':      'https://steamdb.info/instantsearch/?query={}',
		'ss':      'https://store.steampowered.com/search/?term={}',
		'w':       'https://www.wikipedia.org/w/index.php?title=Special:Search&search={}',
		'y':       'https://www.youtube.com/results?search_query={}',
		}

config.unbind('q')
config.unbind('U')

config.bind('<ctrl+f>', 'cmd-set-text /')

config.bind('<Escape>', 
			'clear-messages ;; '
			'clear-keychain ;; '
			'search')

config.bind('<ctrl+b>', 'bookmark-list')

config.bind('h', 'tab-prev')
config.bind('l', 'tab-next')

config.unbind('th')
config.bind('<ctrl+h>', 'back -t')
config.unbind('tl')
config.bind('<ctrl+l>', 'forward -t')

config.unbind('d')
config.bind('x', 'tab-close')
config.unbind('D')
config.bind('X', 'undo')
config.bind('<ctrl+x>', 'undo -w')

config.bind('<', 'tab-move -')
config.bind('>', 'tab-move +')

config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')

config.bind('ge', 'edit-url')
config.bind('gE', 'edit-url --tab')

config.bind('th', 'config-cycle statusbar.show in-mode always')
config.bind('tt', 'config-cycle tabs.show switching multiple')

config.bind('tn', 
			'fullscreen --enter ;; '
			'set statusbar.show in-mode ;;'
			'set tabs.show switching'
			)
config.bind('tw', 
			'fullscreen ;; '
			'set statusbar.show always ;;'
			'set tabs.show multiple')

config.bind('cl', 'tab-only --prev')
config.bind('ch', 'tab-only --next')

config.unbind('pp')
config.unbind('pP')
config.unbind('Pp')
config.unbind('PP')
config.bind('p', 'open -- {clipboard}')
config.bind('P', 'open -t -- {clipboard}')

config.bind('yt', 'tab-clone')

config.bind('e', 'cmd-set-text --space :tab-give')
config.bind('E', 'cmd-set-text --space :tab-take')

config.bind('<alt+b>', 'spawn --userscript --verbose qute-bitwarden.py')
config.bind('<alt+u>', 'spawn --userscript --verbose qute-bitwarden.py --username-only')
config.bind('<alt+p>', 'spawn --userscript --verbose qute-bitwarden.py --password-only')

config.bind('<alt+u>', 'spawn --userscript qute-bitwarden --username-only', mode='prompt')
config.bind('<alt+p>', 'spawn --userscript qute-bitwarden --password-only', mode='prompt')

config.bind('<alt+d>', 'set colors.webpage.darkmode.enabled true')
config.bind('<alt+l>', 'set colors.webpage.darkmode.enabled false')
