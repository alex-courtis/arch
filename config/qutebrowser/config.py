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

## Bindings for normal mode
# config.bind("'", 'mode-enter jump_mark')
# config.bind('+', 'zoom-in')
# config.bind('-', 'zoom-out')
# config.bind('.', 'cmd-repeat-last')
# config.bind('/', 'cmd-set-text /')
# config.bind(':', 'cmd-set-text :')
# config.bind(';I', 'hint images tab')
# config.bind(';O', 'hint links fill :open -t -r {hint-url}')
# config.bind(';R', 'hint --rapid links window')
# config.bind(';Y', 'hint links yank-primary')
# config.bind(';b', 'hint all tab-bg')
# config.bind(';d', 'hint links download')
# config.bind(';f', 'hint all tab-fg')
# config.bind(';h', 'hint all hover')
# config.bind(';i', 'hint images')
# config.bind(';o', 'hint links fill :open {hint-url}')
# config.bind(';r', 'hint --rapid links tab-bg')
# config.bind(';t', 'hint inputs')
# config.bind(';y', 'hint links yank')
# config.bind('<Alt-1>', 'tab-focus 1')
# config.bind('<Alt-2>', 'tab-focus 2')
# config.bind('<Alt-3>', 'tab-focus 3')
# config.bind('<Alt-4>', 'tab-focus 4')
# config.bind('<Alt-5>', 'tab-focus 5')
# config.bind('<Alt-6>', 'tab-focus 6')
# config.bind('<Alt-7>', 'tab-focus 7')
# config.bind('<Alt-8>', 'tab-focus 8')
# config.bind('<Alt-9>', 'tab-focus -1')
# config.bind('<Alt-m>', 'tab-mute')
# config.bind('<Ctrl-A>', 'navigate increment')
# config.bind('<Ctrl-Alt-p>', 'print')
# config.bind('<Ctrl-B>', 'scroll-page 0 -1')
# config.bind('<Ctrl-D>', 'scroll-page 0 0.5')
# config.bind('<Ctrl-F5>', 'reload -f')
# config.bind('<Ctrl-F>', 'scroll-page 0 1')
config.unbind('<Ctrl-N>') # 'open -w')
# config.bind('<Ctrl-PgDown>', 'tab-next')
# config.bind('<Ctrl-PgUp>', 'tab-prev')
# config.bind('<Ctrl-Q>', 'quit')
# config.bind('<Ctrl-Return>', 'selection-follow -t')
# config.bind('<Ctrl-Shift-N>', 'open -p')
# config.bind('<Ctrl-Shift-T>', 'undo')
# config.bind('<Ctrl-Shift-Tab>', 'nop')
# config.bind('<Ctrl-Shift-W>', 'close')
config.unbind('<Ctrl-T>') # 'open -t')
config.unbind('<Ctrl-Tab>') # 'tab-focus last')
# config.bind('<Ctrl-U>', 'scroll-page 0 -0.5')
# config.bind('<Ctrl-V>', 'mode-enter passthrough')
config.unbind('<Ctrl-W>') # 'tab-close')
# config.bind('<Ctrl-X>', 'navigate decrement')
# config.bind('<Ctrl-^>', 'tab-focus last')
# config.bind('<Ctrl-h>', 'home')
# config.bind('<Ctrl-p>', 'tab-pin')
# config.bind('<Ctrl-s>', 'stop')
# config.bind('<Escape>', 'clear-keychain ;; search ;; fullscreen --leave')
config.unbind('<F11>') # 'fullscreen')
# config.bind('<F5>', 'reload')
# config.bind('<Return>', 'selection-follow')
# config.bind('<back>', 'back')
# config.bind('<forward>', 'forward')
# config.bind('=', 'zoom')
# config.bind('?', 'cmd-set-text ?')
# config.bind('@', 'macro-run')
config.unbind('B') # 'cmd-set-text -s :quickmark-load -t')
config.unbind('D') # 'tab-close -o')
# config.bind('F', 'hint all tab')
# config.bind('G', 'scroll-to-perc')
# config.bind('H', 'back')
# config.bind('J', 'tab-next')
# config.bind('K', 'tab-prev')
# config.bind('L', 'forward')
config.unbind('M') # 'bookmark-add')
# config.bind('N', 'search-prev')
config.unbind('O') # 'cmd-set-text -s :open -t')
config.unbind('PP') # 'open -t -- {primary}')
config.unbind('Pp') # 'open -t -- {clipboard}')
# config.bind('R', 'reload -f')
# config.bind('Sb', 'bookmark-list --jump')
# config.bind('Sh', 'history')
# config.bind('Sq', 'bookmark-list')
# config.bind('Ss', 'set')
# config.bind('T', 'cmd-set-text -sr :tab-focus')
config.unbind('U') # 'undo -w')
# config.bind('V', 'mode-enter caret ;; selection-toggle --line')
config.unbind('ZQ') # 'quit')
config.unbind('ZZ') # 'quit --save')
# config.bind('[[', 'navigate prev')
# config.bind(']]', 'navigate next')
# config.bind('`', 'mode-enter set_mark')
# config.bind('ad', 'download-cancel')
config.unbind('b') # 'cmd-set-text -s :quickmark-load')
config.unbind('cd') # 'download-clear')
config.unbind('co') # 'tab-only')
config.unbind('d') # 'tab-close')
# config.bind('f', 'hint')
# config.bind('g$', 'tab-focus -1')
# config.bind('g0', 'tab-focus 1')
config.unbind('gB') # 'cmd-set-text -s :bookmark-load -t')
# config.bind('gC', 'tab-clone')
# config.bind('gD', 'tab-give')
# config.bind('gJ', 'tab-move +')
# config.bind('gK', 'tab-move -')
# config.bind('gO', 'cmd-set-text :open -t -r {url:pretty}')
# config.bind('gU', 'navigate up -t')
# config.bind('g^', 'tab-focus 1')
# config.bind('ga', 'open -t')
config.unbind('gb') # 'cmd-set-text -s :bookmark-load')
# config.bind('gd', 'download')
# config.bind('gf', 'view-source')
# config.bind('gg', 'scroll-to-perc 0')
# config.bind('gi', 'hint inputs --first')
# config.bind('gm', 'tab-move')
# config.bind('go', 'cmd-set-text :open {url:pretty}')
# config.bind('gt', 'cmd-set-text -s :tab-select')
# config.bind('gu', 'navigate up')
# config.bind('h', 'scroll left')
# config.bind('i', 'mode-enter insert')
# config.bind('j', 'scroll down')
# config.bind('k', 'scroll up')
# config.bind('l', 'scroll right')
config.unbind('m') # 'quickmark-save')
# config.bind('n', 'search-next')
config.unbind('o') # 'cmd-set-text -s :open')
config.unbind('pP') # 'open -- {primary}')
config.unbind('pp') # 'open -- {clipboard}')
config.unbind('q') # 'macro-record')
# config.bind('r', 'reload')
config.unbind('sf') # 'save')
config.unbind('sk') # 'cmd-set-text -s :bind')
config.unbind('sl') # 'cmd-set-text -s :set -t')
config.unbind('ss') # 'cmd-set-text -s :set')
config.unbind('tCH') # 'config-cycle -p -u *://*.{url:host}/* content.cookies.accept all no-3rdparty never ;; reload')
config.unbind('tCh') # 'config-cycle -p -u *://{url:host}/* content.cookies.accept all no-3rdparty never ;; reload')
config.unbind('tCu') # 'config-cycle -p -u {url} content.cookies.accept all no-3rdparty never ;; reload')
config.unbind('tIH') # 'config-cycle -p -u *://*.{url:host}/* content.images ;; reload')
config.unbind('tIh') # 'config-cycle -p -u *://{url:host}/* content.images ;; reload')
config.unbind('tIu') # 'config-cycle -p -u {url} content.images ;; reload')
config.unbind('tPH') # 'config-cycle -p -u *://*.{url:host}/* content.plugins ;; reload')
config.unbind('tPh') # 'config-cycle -p -u *://{url:host}/* content.plugins ;; reload')
config.unbind('tPu') # 'config-cycle -p -u {url} content.plugins ;; reload')
config.unbind('tSH') # 'config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload')
config.unbind('tSh') # 'config-cycle -p -u *://{url:host}/* content.javascript.enabled ;; reload')
config.unbind('tSu') # 'config-cycle -p -u {url} content.javascript.enabled ;; reload')
config.unbind('tcH') # 'config-cycle -p -t -u *://*.{url:host}/* content.cookies.accept all no-3rdparty never ;; reload')
config.unbind('tch') # 'config-cycle -p -t -u *://{url:host}/* content.cookies.accept all no-3rdparty never ;; reload')
config.unbind('tcu') # 'config-cycle -p -t -u {url} content.cookies.accept all no-3rdparty never ;; reload')
config.unbind('th') # 'back -t')
config.unbind('tiH') # 'config-cycle -p -t -u *://*.{url:host}/* content.images ;; reload')
config.unbind('tih') # 'config-cycle -p -t -u *://{url:host}/* content.images ;; reload')
config.unbind('tiu') # 'config-cycle -p -t -u {url} content.images ;; reload')
config.unbind('tl') # 'forward -t')
config.unbind('tpH') # 'config-cycle -p -t -u *://*.{url:host}/* content.plugins ;; reload')
config.unbind('tph') # 'config-cycle -p -t -u *://{url:host}/* content.plugins ;; reload')
config.unbind('tpu') # 'config-cycle -p -t -u {url} content.plugins ;; reload')
config.unbind('tsH') # 'config-cycle -p -t -u *://*.{url:host}/* content.javascript.enabled ;; reload')
config.unbind('tsh') # 'config-cycle -p -t -u *://{url:host}/* content.javascript.enabled ;; reload')
config.unbind('tsu') # 'config-cycle -p -t -u {url} content.javascript.enabled ;; reload')
config.unbind('u') # 'undo')
# config.bind('v', 'mode-enter caret')
config.unbind('wB') # 'cmd-set-text -s :bookmark-load -w')
config.unbind('wIf') # 'devtools-focus')
config.unbind('wIh') # 'devtools left')
config.unbind('wIj') # 'devtools bottom')
config.unbind('wIk') # 'devtools top')
config.unbind('wIl') # 'devtools right')
config.unbind('wIw') # 'devtools window')
config.unbind('wO') # 'cmd-set-text :open -w {url:pretty}')
config.unbind('wP') # 'open -w -- {primary}')
config.unbind('wb') # 'cmd-set-text -s :quickmark-load -w')
config.unbind('wf') # 'hint all window')
config.unbind('wh') # 'back -w')
config.unbind('wi') # 'devtools')
config.unbind('wl') # 'forward -w')
config.unbind('wo') # 'cmd-set-text -s :open -w')
config.unbind('wp') # 'open -w -- {clipboard}')
config.unbind('xO') # 'cmd-set-text :open -b -r {url:pretty}')
config.unbind('xo') # 'cmd-set-text -s :open -b')
# config.bind('yD', 'yank domain -s')
# config.bind('yM', 'yank inline [{title}]({url:yank}) -s')
# config.bind('yP', 'yank pretty-url -s')
# config.bind('yT', 'yank title -s')
# config.bind('yY', 'yank -s')
# config.bind('yd', 'yank domain')
# config.bind('ym', 'yank inline [{title}]({url:yank})')
# config.bind('yp', 'yank pretty-url')
# config.bind('yt', 'yank title')
# config.bind('yy', 'yank')
# config.bind('{{', 'navigate prev -t')
# config.bind('}}', 'navigate next -t')

## Bindings for caret mode
# config.bind('$', 'move-to-end-of-line', mode='caret')
# config.bind('0', 'move-to-start-of-line', mode='caret')
# config.bind('<Ctrl-Space>', 'selection-drop', mode='caret')
# config.bind('<Escape>', 'mode-leave', mode='caret')
# config.bind('<Return>', 'yank selection', mode='caret')
# config.bind('<Space>', 'selection-toggle', mode='caret')
# config.bind('G', 'move-to-end-of-document', mode='caret')
# config.bind('H', 'scroll left', mode='caret')
# config.bind('J', 'scroll down', mode='caret')
# config.bind(K', 'scroll up', mode='caret')
# config.bind('L', 'scroll right', mode='caret')
# config.bind('V', 'selection-toggle --line', mode='caret')
# config.bind('Y', 'yank selection -s', mode='caret')
# config.bind('[', 'move-to-start-of-prev-block', mode='caret')
# config.bind(']', 'move-to-start-of-next-block', mode='caret')
# config.bind('b', 'move-to-prev-word', mode='caret')
# config.bind('c', 'mode-enter normal', mode='caret')
# config.bind('e', 'move-to-end-of-word', mode='caret')
# config.bind('gg', 'move-to-start-of-document', mode='caret')
# config.bind('h', 'move-to-prev-char', mode='caret')
# config.bind('j', 'move-to-next-line', mode='caret')
# config.bind('k', 'move-to-prev-line', mode='caret')
# config.bind('l', 'move-to-next-char', mode='caret')
# config.bind('o', 'selection-reverse', mode='caret')
# config.bind('v', 'selection-toggle', mode='caret')
# config.bind('w', 'move-to-next-word', mode='caret')
# config.bind('y', 'yank selection', mode='caret')
# config.bind('{', 'move-to-end-of-prev-block', mode='caret')
# config.bind('}', 'move-to-end-of-next-block', mode='caret')

## Bindings for command mode
# config.bind('<Alt-B>', 'rl-backward-word', mode='command')
# config.bind('<Alt-Backspace>', 'rl-backward-kill-word', mode='command')
# config.bind('<Alt-D>', 'rl-kill-word', mode='command')
# config.bind('<Alt-F>', 'rl-forward-word', mode='command')
# config.bind('<Ctrl-?>', 'rl-delete-char', mode='command')
# config.bind('<Ctrl-A>', 'rl-beginning-of-line', mode='command')
# config.bind('<Ctrl-B>', 'rl-backward-char', mode='command')
# config.bind('<Ctrl-C>', 'completion-item-yank', mode='command')
# config.bind('<Ctrl-D>', 'completion-item-del', mode='command')
# config.bind('<Ctrl-E>', 'rl-end-of-line', mode='command')
# config.bind('<Ctrl-F>', 'rl-forward-char', mode='command')
# config.bind('<Ctrl-H>', 'rl-backward-delete-char', mode='command')
# config.bind('<Ctrl-K>', 'rl-kill-line', mode='command')
# config.bind('<Ctrl-N>', 'command-history-next', mode='command')
# config.bind('<Ctrl-P>', 'command-history-prev', mode='command')
# config.bind('<Ctrl-Return>', 'command-accept --rapid', mode='command')
# config.bind('<Ctrl-Shift-C>', 'completion-item-yank --sel', mode='command')
# config.bind('<Ctrl-Shift-Tab>', 'completion-item-focus prev-category', mode='command')
# config.bind('<Ctrl-Shift-W>', 'rl-filename-rubout', mode='command')
# config.bind('<Ctrl-Tab>', 'completion-item-focus next-category', mode='command')
# config.bind('<Ctrl-U>', 'rl-unix-line-discard', mode='command')
# config.bind('<Ctrl-W>', 'rl-rubout " "', mode='command')
# config.bind('<Ctrl-Y>', 'rl-yank', mode='command')
# config.bind('<Down>', 'completion-item-focus --history next', mode='command')
# config.bind('<Escape>', 'mode-leave', mode='command')
# config.bind('<PgDown>', 'completion-item-focus next-page', mode='command')
# config.bind('<PgUp>', 'completion-item-focus prev-page', mode='command')
# config.bind('<Return>', 'command-accept', mode='command')
# config.bind('<Shift-Delete>', 'completion-item-del', mode='command')
# config.bind('<Shift-Tab>', 'completion-item-focus prev', mode='command')
# config.bind('<Tab>', 'completion-item-focus next', mode='command')
# config.bind('<Up>', 'completion-item-focus --history prev', mode='command')

## Bindings for hint mode
# config.bind('<Ctrl-B>', 'hint all tab-bg', mode='hint')
# config.bind('<Ctrl-F>', 'hint links', mode='hint')
# config.bind('<Ctrl-R>', 'hint --rapid links tab-bg', mode='hint')
# config.bind('<Escape>', 'mode-leave', mode='hint')
# config.bind('<Return>', 'hint-follow', mode='hint')

## Bindings for insert mode
# config.bind('<Ctrl-E>', 'edit-text', mode='insert')
# config.bind('<Escape>', 'mode-leave', mode='insert')
# config.bind('<Shift-Escape>', 'fake-key <Escape>', mode='insert')
# config.bind('<Shift-Ins>', 'insert-text -- {primary}', mode='insert')

## Bindings for passthrough mode
# config.bind('<Shift-Escape>', 'mode-leave', mode='passthrough')

## Bindings for prompt mode
# config.bind('<Alt-B>', 'rl-backward-word', mode='prompt')
# config.bind('<Alt-Backspace>', 'rl-backward-kill-word', mode='prompt')
# config.bind('<Alt-D>', 'rl-kill-word', mode='prompt')
# config.bind('<Alt-E>', 'prompt-fileselect-external', mode='prompt')
# config.bind('<Alt-F>', 'rl-forward-word', mode='prompt')
# config.bind('<Alt-Shift-Y>', 'prompt-yank --sel', mode='prompt')
# config.bind('<Alt-Y>', 'prompt-yank', mode='prompt')
# config.bind('<Ctrl-?>', 'rl-delete-char', mode='prompt')
# config.bind('<Ctrl-A>', 'rl-beginning-of-line', mode='prompt')
# config.bind('<Ctrl-B>', 'rl-backward-char', mode='prompt')
# config.bind('<Ctrl-E>', 'rl-end-of-line', mode='prompt')
# config.bind('<Ctrl-F>', 'rl-forward-char', mode='prompt')
# config.bind('<Ctrl-H>', 'rl-backward-delete-char', mode='prompt')
# config.bind('<Ctrl-K>', 'rl-kill-line', mode='prompt')
# config.bind('<Ctrl-P>', 'prompt-open-download --pdfjs', mode='prompt')
# config.bind('<Ctrl-Shift-W>', 'rl-filename-rubout', mode='prompt')
# config.bind('<Ctrl-U>', 'rl-unix-line-discard', mode='prompt')
# config.bind('<Ctrl-W>', 'rl-rubout " "', mode='prompt')
# config.bind('<Ctrl-X>', 'prompt-open-download', mode='prompt')
# config.bind('<Ctrl-Y>', 'rl-yank', mode='prompt')
# config.bind('<Down>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Escape>', 'mode-leave', mode='prompt')
# config.bind('<Return>', 'prompt-accept', mode='prompt')
# config.bind('<Shift-Tab>', 'prompt-item-focus prev', mode='prompt')
# config.bind('<Tab>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Up>', 'prompt-item-focus prev', mode='prompt')

## Bindings for register mode
# config.bind('<Escape>', 'mode-leave', mode='register')

## Bindings for yesno mode
# config.bind('<Alt-Shift-Y>', 'prompt-yank --sel', mode='yesno')
# config.bind('<Alt-Y>', 'prompt-yank', mode='yesno')
# config.bind('<Escape>', 'mode-leave', mode='yesno')
# config.bind('<Return>', 'prompt-accept', mode='yesno')
# config.bind('N', 'prompt-accept --save no', mode='yesno')
# config.bind('Y', 'prompt-accept --save yes', mode='yesno')
# config.bind('n', 'prompt-accept no', mode='yesno')
# config.bind('y', 'prompt-accept yes', mode='yesno')


# TODO 
# - y
# - g
# - ;
# - unbind remaining normal defaults when done

config.bind('b',  'cmd-set-text --space :quickmark-load')
config.bind('tb', 'cmd-set-text --space :quickmark-load --tab')
config.bind('wb', 'cmd-set-text --space :quickmark-load --window')

config.bind('m',  'cmd-set-text --space :bookmark-load')
config.bind('tm', 'cmd-set-text --space :bookmark-load --tab')
config.bind('wm', 'cmd-set-text --space :bookmark-load --window')

config.bind('<Ctrl-W>', 'tab-close')
config.bind('tc', 'tab-close')
config.bind('<Ctrl-Shift-W>', 'close')
config.bind('wc', 'close')

config.bind('tu', 'undo')
config.bind('wu', 'undo --window')

config.bind('th', 'back --tab')
config.bind('wh', 'back --tab')
config.bind('tl', 'forward --tab')
config.bind('wl', 'forward --window')

config.bind('td', 'tab-clone')
config.bind('wd', 'tab-clone --window')

config.bind('tg', 'cmd-set-text --space :tab-give')
config.bind('wt', 'cmd-set-text --space :tab-take')

config.bind('p',  'open -- {clipboard}')
config.bind('tp', 'open --tab -- {clipboard}')
config.bind('wp', 'open --window -- {clipboard}')

config.bind('s',  'open -- {primary}')
config.bind('ts', 'open --tab -- {primary}')
config.bind('ws', 'open --window -- {primary}')

config.bind('o',  'cmd-set-text --space :open')
config.bind('to', 'cmd-set-text --space :open --tab')
config.bind('wo', 'cmd-set-text --space :open --window')

config.bind('e',  'cmd-set-text :open {url:pretty}')
config.bind('te', 'cmd-set-text :open --tab {url:pretty}')
config.bind('we', 'cmd-set-text :open --window {url:pretty}')

config.bind('E',  'edit-url')
config.bind('tE', 'edit-url --tab')
config.bind('wE', 'edit-url --window')

config.bind('tt', 'open --tab')
config.bind('ww', 'open --window')

config.bind('z', 
			'fullscreen --enter ;; '
			'set statusbar.show in-mode ;; '
			'set tabs.show switching'
			)
config.bind('Z', 
			'fullscreen ;; '
			'set statusbar.show always ;; '
			'set tabs.show multiple')

config.bind('<ctrl+f>', 'cmd-set-text /')

config.bind('<Escape>', 
			'clear-messages ;; '
			'clear-keychain ;; '
			'search')

config.bind('<ctrl+shift+b>', 'bookmark-list --tab')

config.bind('^', 'tab-focus last')

config.bind('h', 'tab-prev')
config.bind('l', 'tab-next')

config.bind('<ctrl+h>', 'tab-move -')
config.bind('<ctrl+l>', 'tab-move +')

config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')

config.bind('co', 'tab-only')
config.bind('cw', 'window-only')
config.bind('cl', 'tab-only --prev')
config.bind('ch', 'tab-only --next')

config.bind('<alt+b>', 'spawn --userscript --verbose qute-bitwarden.py')
config.bind('<alt+u>', 'spawn --userscript --verbose qute-bitwarden.py --username-only')
config.bind('<alt+p>', 'spawn --userscript --verbose qute-bitwarden.py --password-only')

config.bind('<alt+u>', 'spawn --userscript qute-bitwarden --username-only', mode='prompt')
config.bind('<alt+p>', 'spawn --userscript qute-bitwarden --password-only', mode='prompt')

config.bind('<alt+d>', 'set colors.webpage.darkmode.enabled true')
config.bind('<alt+l>', 'set colors.webpage.darkmode.enabled false')
