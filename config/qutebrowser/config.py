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

c.tabs.background = False

# many issues exist with in-mode e.g. https://github.com/qutebrowser/qutebrowser/issues/5520
c.statusbar.show = 'always'
c.tabs.show = 'multiple'

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
config.unbind("'") # 'mode-enter jump_mark')
config.unbind('+') # zoom-in')
config.unbind('-') # zoom-out')
config.unbind('.') # cmd-repeat-last')
config.unbind('/') # cmd-set-text /')
config.unbind(':') # cmd-set-text :')
config.unbind(';I') # hint images tab')
config.unbind(';O') # hint links fill :open -t -r {hint-url}')
config.unbind(';R') # hint --rapid links window')
config.unbind(';Y') # hint links yank-primary')
config.unbind(';b') # hint all tab-bg')
config.unbind(';d') # hint links download')
config.unbind(';f') # hint all tab-fg')
config.unbind(';h') # hint all hover')
config.unbind(';i') # hint images')
config.unbind(';o') # hint links fill :open {hint-url}')
config.unbind(';r') # hint --rapid links tab-bg')
config.unbind(';t') # hint inputs')
config.unbind(';y') # hint links yank')
config.unbind('<Alt-1>') # tab-focus 1')
config.unbind('<Alt-2>') # tab-focus 2')
config.unbind('<Alt-3>') # tab-focus 3')
config.unbind('<Alt-4>') # tab-focus 4')
config.unbind('<Alt-5>') # tab-focus 5')
config.unbind('<Alt-6>') # tab-focus 6')
config.unbind('<Alt-7>') # tab-focus 7')
config.unbind('<Alt-8>') # tab-focus 8')
config.unbind('<Alt-9>') # tab-focus -1')
config.unbind('<Alt-m>') # tab-mute')
config.unbind('<Ctrl-A>') # navigate increment')
config.unbind('<Ctrl-Alt-p>') # print')
config.unbind('<Ctrl-B>') # scroll-page 0 -1')
config.unbind('<Ctrl-D>') # scroll-page 0 0.5')
config.unbind('<Ctrl-F5>') # reload -f')
config.unbind('<Ctrl-F>') # scroll-page 0 1')
config.unbind('<Ctrl-N>') # 'open -w')
config.unbind('<Ctrl-PgDown>') # tab-next')
config.unbind('<Ctrl-PgUp>') # tab-prev')
config.unbind('<Ctrl-Q>') # quit')
config.unbind('<Ctrl-Return>') # selection-follow -t')
config.unbind('<Ctrl-Shift-N>') # open -p')
config.unbind('<Ctrl-Shift-T>') # undo')
config.unbind('<Ctrl-Shift-Tab>') # nop')
config.unbind('<Ctrl-Shift-W>') # close')
config.unbind('<Ctrl-T>') # 'open -t')
config.unbind('<Ctrl-Tab>') # 'tab-focus last')
config.unbind('<Ctrl-U>') # scroll-page 0 -0.5')
config.unbind('<Ctrl-V>') # mode-enter passthrough')
config.unbind('<Ctrl-W>') # 'tab-close')
config.unbind('<Ctrl-X>') # navigate decrement')
config.unbind('<Ctrl-^>') # tab-focus last')
config.unbind('<Ctrl-h>') # home')
config.unbind('<Ctrl-p>') # tab-pin')
config.unbind('<Ctrl-s>') # stop')
config.unbind('<Escape>') # clear-keychain ;; search ;; fullscreen --leave')
config.unbind('<F11>') # 'fullscreen')
config.unbind('<F5>') # reload')
config.unbind('<Return>') # selection-follow')
config.unbind('<back>') # back')
config.unbind('<forward>') # forward')
config.unbind('=') # zoom')
config.unbind('?') # cmd-set-text ?')
config.unbind('@') # macro-run')
config.unbind('B') # 'cmd-set-text -s :quickmark-load -t')
config.unbind('D') # 'tab-close -o')
config.unbind('F') # 'hint all tab')
config.unbind('G') # scroll-to-perc')
config.unbind('H') # back')
config.unbind('J') # tab-next')
config.unbind('K') # tab-prev')
config.unbind('L') # forward')
config.unbind('M') # 'bookmark-add')
config.unbind('N') # search-prev')
config.unbind('O') # 'cmd-set-text -s :open -t')
config.unbind('PP') # 'open -t -- {primary}')
config.unbind('Pp') # 'open -t -- {clipboard}')
config.unbind('R') # reload -f')
config.unbind('Sb') # bookmark-list --jump')
config.unbind('Sh') # history')
config.unbind('Sq') # bookmark-list')
config.unbind('Ss') # set')
config.unbind('T') # cmd-set-text -sr :tab-focus')
config.unbind('U') # 'undo -w')
config.unbind('V') # mode-enter caret ;; selection-toggle --line')
config.unbind('ZQ') # 'quit')
config.unbind('ZZ') # 'quit --save')
config.unbind('[[') # navigate prev')
config.unbind(']]') # navigate next')
config.unbind('`') # mode-enter set_mark')
config.unbind('ad') # download-cancel')
config.unbind('b') # 'cmd-set-text -s :quickmark-load')
config.unbind('cd') # 'download-clear')
config.unbind('co') # 'tab-only')
config.unbind('d') # 'tab-close')
config.unbind('f') # 'hint')
# config.unbind('g$') # tab-focus -1')
# config.unbind('g0') # tab-focus 1')
config.unbind('gB') # 'cmd-set-text -s :bookmark-load -t')
# config.unbind('gC') # tab-clone')
# config.unbind('gD') # tab-give')
# config.unbind('gJ') # tab-move +')
# config.unbind('gK') # tab-move -')
# config.unbind('gO') # cmd-set-text :open -t -r {url:pretty}')
# config.unbind('gU') # navigate up -t')
# config.unbind('g^') # tab-focus 1')
# config.unbind('ga') # open -t')
config.unbind('gb') # 'cmd-set-text -s :bookmark-load')
# config.unbind('gd') # download')
# config.unbind('gf') # view-source')
# config.unbind('gg') # scroll-to-perc 0')
# config.unbind('gi') # hint inputs --first')
# config.unbind('gm') # tab-move')
# config.unbind('go') # cmd-set-text :open {url:pretty}')
# config.unbind('gt') # cmd-set-text -s :tab-select')
# config.unbind('gu') # navigate up')
config.unbind('h') # scroll left')
config.unbind('i') # mode-enter insert')
config.unbind('j') # scroll down')
config.unbind('k') # scroll up')
config.unbind('l') # scroll right')
config.unbind('m') # 'quickmark-save')
config.unbind('n') # search-next')
config.unbind('o') # 'cmd-set-text -s :open')
config.unbind('pP') # 'open -- {primary}')
config.unbind('pp') # 'open -- {clipboard}')
config.unbind('q') # 'macro-record')
config.unbind('r') # reload')
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
config.unbind('v') # mode-enter caret')
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
config.unbind('yD') # yank domain -s')
config.unbind('yM') # yank inline [{title}]({url:yank}) -s')
config.unbind('yP') # yank pretty-url -s')
config.unbind('yT') # yank title -s')
config.unbind('yY') # yank -s')
config.unbind('yd') # yank domain')
config.unbind('ym') # yank inline [{title}]({url:yank})')
config.unbind('yp') # yank pretty-url')
config.unbind('yt') # yank title')
config.unbind('yy') # yank')
config.unbind('{{') # navigate prev -t')
config.unbind('}}') # navigate next -t')

## Bindings for caret mode
# config.unbind('$') # move-to-end-of-line', mode='caret')
# config.unbind('0') # move-to-start-of-line', mode='caret')
# config.unbind('<Ctrl-Space>') # selection-drop', mode='caret')
# config.unbind('<Escape>') # mode-leave', mode='caret')
# config.unbind('<Return>') # yank selection', mode='caret')
# config.unbind('<Space>') # selection-toggle', mode='caret')
# config.unbind('G') # move-to-end-of-document', mode='caret')
# config.unbind('H') # scroll left', mode='caret')
# config.unbind('J') # scroll down', mode='caret')
# config.unbind(K') # scroll up', mode='caret')
# config.unbind('L') # scroll right', mode='caret')
# config.unbind('V') # selection-toggle --line', mode='caret')
# config.unbind('Y') # yank selection -s', mode='caret')
# config.unbind('[') # move-to-start-of-prev-block', mode='caret')
# config.unbind(']') # move-to-start-of-next-block', mode='caret')
# config.unbind('b') # move-to-prev-word', mode='caret')
# config.unbind('c') # mode-enter normal', mode='caret')
# config.unbind('e') # move-to-end-of-word', mode='caret')
# config.unbind('gg') # move-to-start-of-document', mode='caret')
# config.unbind('h') # move-to-prev-char', mode='caret')
# config.unbind('j') # move-to-next-line', mode='caret')
# config.unbind('k') # move-to-prev-line', mode='caret')
# config.unbind('l') # move-to-next-char', mode='caret')
# config.unbind('o') # selection-reverse', mode='caret')
# config.unbind('v') # selection-toggle', mode='caret')
# config.unbind('w') # move-to-next-word', mode='caret')
# config.unbind('y') # yank selection', mode='caret')
# config.unbind('{') # move-to-end-of-prev-block', mode='caret')
# config.unbind('}') # move-to-end-of-next-block', mode='caret')

## Bindings for command mode
# config.unbind('<Alt-B>') # rl-backward-word', mode='command')
# config.unbind('<Alt-Backspace>') # rl-backward-kill-word', mode='command')
# config.unbind('<Alt-D>') # rl-kill-word', mode='command')
# config.unbind('<Alt-F>') # rl-forward-word', mode='command')
# config.unbind('<Ctrl-?>') # rl-delete-char', mode='command')
# config.unbind('<Ctrl-A>') # rl-beginning-of-line', mode='command')
# config.unbind('<Ctrl-B>') # rl-backward-char', mode='command')
# config.unbind('<Ctrl-C>') # completion-item-yank', mode='command')
# config.unbind('<Ctrl-D>') # completion-item-del', mode='command')
# config.unbind('<Ctrl-E>') # rl-end-of-line', mode='command')
# config.unbind('<Ctrl-F>') # rl-forward-char', mode='command')
# config.unbind('<Ctrl-H>') # rl-backward-delete-char', mode='command')
# config.unbind('<Ctrl-K>') # rl-kill-line', mode='command')
# config.unbind('<Ctrl-N>') # command-history-next', mode='command')
# config.unbind('<Ctrl-P>') # command-history-prev', mode='command')
# config.unbind('<Ctrl-Return>') # command-accept --rapid', mode='command')
# config.unbind('<Ctrl-Shift-C>') # completion-item-yank --sel', mode='command')
# config.unbind('<Ctrl-Shift-Tab>') # completion-item-focus prev-category', mode='command')
# config.unbind('<Ctrl-Shift-W>') # rl-filename-rubout', mode='command')
# config.unbind('<Ctrl-Tab>') # completion-item-focus next-category', mode='command')
# config.unbind('<Ctrl-U>') # rl-unix-line-discard', mode='command')
# config.unbind('<Ctrl-W>') # rl-rubout " "', mode='command')
# config.unbind('<Ctrl-Y>') # rl-yank', mode='command')
# config.unbind('<Down>') # completion-item-focus --history next', mode='command')
# config.unbind('<Escape>') # mode-leave', mode='command')
# config.unbind('<PgDown>') # completion-item-focus next-page', mode='command')
# config.unbind('<PgUp>') # completion-item-focus prev-page', mode='command')
# config.unbind('<Return>') # command-accept', mode='command')
# config.unbind('<Shift-Delete>') # completion-item-del', mode='command')
# config.unbind('<Shift-Tab>') # completion-item-focus prev', mode='command')
# config.unbind('<Tab>') # completion-item-focus next', mode='command')
# config.unbind('<Up>') # completion-item-focus --history prev', mode='command')

## Bindings for hint mode
# config.unbind('<Ctrl-B>') # hint all tab-bg', mode='hint')
# config.unbind('<Ctrl-F>') # hint links', mode='hint')
# config.unbind('<Ctrl-R>') # hint --rapid links tab-bg', mode='hint')
# config.unbind('<Escape>') # mode-leave', mode='hint')
# config.unbind('<Return>') # hint-follow', mode='hint')

## Bindings for insert mode
# config.unbind('<Ctrl-E>') # edit-text', mode='insert')
# config.unbind('<Escape>') # mode-leave', mode='insert')
# config.unbind('<Shift-Escape>') # fake-key <Escape>', mode='insert')
# config.unbind('<Shift-Ins>') # insert-text -- {primary}', mode='insert')

## Bindings for passthrough mode
# config.unbind('<Shift-Escape>') # mode-leave', mode='passthrough')

## Bindings for prompt mode
# config.unbind('<Alt-B>') # rl-backward-word', mode='prompt')
# config.unbind('<Alt-Backspace>') # rl-backward-kill-word', mode='prompt')
# config.unbind('<Alt-D>') # rl-kill-word', mode='prompt')
# config.unbind('<Alt-E>') # prompt-fileselect-external', mode='prompt')
# config.unbind('<Alt-F>') # rl-forward-word', mode='prompt')
# config.unbind('<Alt-Shift-Y>') # prompt-yank --sel', mode='prompt')
# config.unbind('<Alt-Y>') # prompt-yank', mode='prompt')
# config.unbind('<Ctrl-?>') # rl-delete-char', mode='prompt')
# config.unbind('<Ctrl-A>') # rl-beginning-of-line', mode='prompt')
# config.unbind('<Ctrl-B>') # rl-backward-char', mode='prompt')
# config.unbind('<Ctrl-E>') # rl-end-of-line', mode='prompt')
# config.unbind('<Ctrl-F>') # rl-forward-char', mode='prompt')
# config.unbind('<Ctrl-H>') # rl-backward-delete-char', mode='prompt')
# config.unbind('<Ctrl-K>') # rl-kill-line', mode='prompt')
# config.unbind('<Ctrl-P>') # prompt-open-download --pdfjs', mode='prompt')
# config.unbind('<Ctrl-Shift-W>') # rl-filename-rubout', mode='prompt')
# config.unbind('<Ctrl-U>') # rl-unix-line-discard', mode='prompt')
# config.unbind('<Ctrl-W>') # rl-rubout " "', mode='prompt')
# config.unbind('<Ctrl-X>') # prompt-open-download', mode='prompt')
# config.unbind('<Ctrl-Y>') # rl-yank', mode='prompt')
# config.unbind('<Down>') # prompt-item-focus next', mode='prompt')
# config.unbind('<Escape>') # mode-leave', mode='prompt')
# config.unbind('<Return>') # prompt-accept', mode='prompt')
# config.unbind('<Shift-Tab>') # prompt-item-focus prev', mode='prompt')
# config.unbind('<Tab>') # prompt-item-focus next', mode='prompt')
# config.unbind('<Up>') # prompt-item-focus prev', mode='prompt')

## Bindings for register mode
# config.unbind('<Escape>') # mode-leave', mode='register')

## Bindings for yesno mode
# config.unbind('<Alt-Shift-Y>') # prompt-yank --sel', mode='yesno')
# config.unbind('<Alt-Y>') # prompt-yank', mode='yesno')
# config.unbind('<Escape>') # mode-leave', mode='yesno')
# config.unbind('<Return>') # prompt-accept', mode='yesno')
# config.unbind('N') # prompt-accept --save no', mode='yesno')
# config.unbind('Y') # prompt-accept --save yes', mode='yesno')
# config.unbind('n') # prompt-accept no', mode='yesno')
# config.unbind('y') # prompt-accept yes', mode='yesno')


# TODO 
# - g
# - private
# - queue tab opens
# - maybe c.bindings.default = {} or just clear undesirables

config.bind('b',  'cmd-set-text --space :quickmark-load')
config.bind('tb', 'cmd-set-text --space :quickmark-load --tab')
config.bind('wb', 'cmd-set-text --space :quickmark-load --window')

config.bind('m',  'cmd-set-text --space :bookmark-load')
config.bind('tm', 'cmd-set-text --space :bookmark-load --tab')
config.bind('wm', 'cmd-set-text --space :bookmark-load --window')

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

config.bind('P',  'open -- {primary}')
config.bind('tP', 'open --tab -- {primary}')
config.bind('wP', 'open --window -- {primary}')

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

config.bind('x', 'tab-close')
config.bind('<Ctrl-W>', 'tab-close')
config.bind('X', 'close')
config.bind('<Ctrl-Shift-W>', 'close')

config.bind('s', 'tab-focus last')
config.bind('S', 'cmd-set-text --space --run-on-count :tab-focus')

config.bind('f',  'hint links')
config.bind('F',  'hint links tab-bg')
config.bind('tf', 'hint links tab')
config.bind('wf', 'hint links window')

config.bind('a',  'hint all')
config.bind('A',  'hint all tab-bg')
config.bind('ta', 'hint all tab')
config.bind('wa', 'hint all window')

config.bind(';d', 'hint links download')
config.bind(';i', 'hint images')
config.bind(';h', 'hint all hover')
config.bind(';y', 'hint links yank')
config.bind(';Y', 'hint links yank-primary')

config.bind(';o',  'hint links fill :open {hint-url}')
config.bind(';to', 'hint links fill :open --tab {hint-url}')
config.bind(';wo', 'hint links fill :open --window {hint-url}')

config.bind('yd', 'yank domain')
config.bind('yD', 'yank domain --sel')
config.bind('ym', 'yank inline [{title}]({url:yank})')
config.bind('yM', 'yank inline [{title}]({url:yank}) --sel')
config.bind('yp', 'yank pretty-url')
config.bind('yP', 'yank pretty-url --sel')
config.bind('yt', 'yank title')
config.bind('yT', 'yank title --sel')
config.bind('yy', 'yank url')
config.bind('yY', 'yank url --sel')

config.bind('h', 'scroll left')
config.bind('i', 'mode-enter insert')
config.bind('j', 'scroll down')
config.bind('k', 'scroll up')
config.bind('l', 'scroll right')
config.bind('n', 'search-next')
config.bind('r', 'reload')
config.bind('v', 'mode-enter caret')

config.bind('G', 'scroll-to-perc')
config.bind('H', 'back')
config.bind('L', 'forward')
config.bind('N', 'search-prev')
config.bind('R', 'reload -f')
config.bind('V', 'mode-enter caret ;; selection-toggle --line')

config.bind('Z', 
			'fullscreen --enter ;; '
			'set statusbar.show in-mode ;; '
			'set tabs.show switching'
			)
config.bind('z', 
			'fullscreen ;; '
			'set statusbar.show always ;; '
			'set tabs.show multiple')

config.bind('<ctrl+f>', 'cmd-set-text /')

config.bind('<Escape>', 
			'clear-messages ;; '
			'clear-keychain ;; '
			'search')

config.bind('<ctrl+shift+b>', 'bookmark-list --tab')

config.bind('<ctrl+shift+h>', 'history --tab')

config.bind('h', 'tab-prev')
config.bind('l', 'tab-next')

config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')

config.bind('ct', 'tab-only')
config.bind('cw', 'window-only')
config.bind('cl', 'tab-only --prev')
config.bind('ch', 'tab-only --next')

config.bind('/', 'cmd-set-text /')
config.bind(':', 'cmd-set-text :')
config.bind('?', 'cmd-set-text ?')

config.bind('+', 'zoom-in')
config.bind('-', 'zoom-out')
config.bind('=', 'zoom')
config.bind('.', 'cmd-repeat-last')

config.bind('<ctrl+d>', 'scroll-page 0 0.5')
config.bind('<ctrl+h>', 'tab-move -')
config.bind('<ctrl+l>', 'tab-move +')
config.bind('<ctrl+n>', 'open --window')
config.bind('<ctrl+q>', 'quit')
config.bind('<ctrl+s>', 'stop')
config.bind('<ctrl+t>', 'open --tab')
config.bind('<ctrl+u>', 'scroll-page 0 -0.5')
config.bind('<ctrl+v>', 'mode-enter passthrough')
config.bind('<ctrl+shift+w>', 'close')

config.bind('<F5>', 'reload')
config.bind('<Ctrl+F5>', 'reload -f')

config.bind('<Return>', 'selection-follow')
config.bind('<back>', 'back')
config.bind('<forward>', 'forward')

config.bind('<alt+b>', 'spawn --userscript --verbose qute-bitwarden.py')
config.bind('<alt+u>', 'spawn --userscript --verbose qute-bitwarden.py --username-only')
config.bind('<alt+p>', 'spawn --userscript --verbose qute-bitwarden.py --password-only')

config.bind('<alt+u>', 'spawn --userscript qute-bitwarden --username-only', mode='prompt')
config.bind('<alt+p>', 'spawn --userscript qute-bitwarden --password-only', mode='prompt')

config.bind('<alt+d>', 'set colors.webpage.darkmode.enabled true')
config.bind('<alt+l>', 'set colors.webpage.darkmode.enabled false')
