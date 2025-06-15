import os

config.source('base16-bright.py')

config.source('bindings.set.py')

# config.source('bindings.print.py')

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

c.hints.chars = 'pgcraoeuhtnsqjkmwvz'

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

c.tabs.background = True
c.tabs.select_on_remove = 'last-used'

# many issues exist with in-mode e.g. https://github.com/qutebrowser/qutebrowser/issues/5520
c.statusbar.show = 'always'
c.tabs.show = 'multiple'

c.statusbar.position = 'top'
c.statusbar.padding = {'bottom': 3, 'left': 0, 'right': 3, 'top': 3}

c.statusbar.widgets = [
		'progress',
		'keypress',     'text:        ',
		'search_match', 'text:        ',
		'history',      'text:        ',
		'tabs',         'text:        ',
		'scroll',
		]

c.content.register_protocol_handler = True

c.search.wrap = False
c.search.wrap_messages = False

c.completion.open_categories = [ 'filesystem', 'searchengines', 'bookmarks', 'quickmarks', 'history' ]

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
