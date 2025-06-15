bw_args = ("--dmenu-invocation "
		   "'bemenu --prompt \"\"' "
		   "--password-prompt-invocation "
		   "'bemenu --prompt \"Master Password\" --password indicator < /dev/null' "
		   )

c.bindings.key_mappings = {}

c.bindings.commands = {
	"normal": {
		# unbinds of defaults, will be overridden by bindings or nops
		"'": None,

		";I": None,
		";O": None,
		";R": None,
		";b": None,
		";f": None,
		";r": None,
		";t": None,

		"<F11>": None,

		"<Alt-1>": None,
		"<Alt-2>": None,
		"<Alt-3>": None,
		"<Alt-4>": None,
		"<Alt-5>": None,
		"<Alt-6>": None,
		"<Alt-7>": None,
		"<Alt-8>": None,
		"<Alt-9>": None,
		"<Alt-m>": None,

		"<Ctrl-PgDown>": None,
		"<Ctrl-PgUp>": None,
		"<Ctrl-Shift-Tab>": None,
		"<Ctrl-Tab>": None,

		"@": None,
		"[[": None,
		"]]": None,
		"`": None,
		"ad": None,
		"B": None,
		"cd": None,
		"co": None,
		"D": None,
		"gB": None,
		"gb": None,

		"g$": None,
		"g0": None,
		"g^": None,
		"ga": None,
		"gC": None,
		"gD": None,
		"gf": None,
		"gJ": None,
		"gK": None,
		"gm": None,
		"go": None,
		"gO": None,
		"gd": None,

		"J": None,
		"K": None,
		"M": None,
		"O": None,
		"PP": None,
		"Pp": None,
		"pP": None,
		"pp": None,
		"q": None,
		"Sb": None,
		"sf": None,
		"Sh": None,
		"sk": None,
		"sl": None,
		"Sq": None,
		"Ss": None,
		"ss": None,
		"T": None,
		"tCH": None,
		"tCh": None,
		"tcH": None,
		"tch": None,
		"tCu": None,
		"tcu": None,
		"tIH": None,
		"tIh": None,
		"tiH": None,
		"tih": None,
		"tIu": None,
		"tiu": None,
		"tPH": None,
		"tPh": None,
		"tpH": None,
		"tph": None,
		"tPu": None,
		"tpu": None,
		"tSH": None,
		"tSh": None,
		"tsH": None,
		"tsh": None,
		"tSu": None,
		"tsu": None,
		"U": None,
		"wB": None,
		"wi": None,
		"wIf": None,
		"wIh": None,
		"wIj": None,
		"wIk": None,
		"wIl": None,
		"wIw": None,
		"wO": None,
		"xO": None,
		"xo": None,
		"ZQ": None,
		"ZZ": None,
		"{{": None,
		"}}": None,

		# bindings, using None for browser handled control keys
		"<Escape>": "clear-messages ;; clear-keychain ;; search",

		"<Shift-return>": "selection-follow --tab",

		"<Ctrl-return>": None,

		"<Ctrl-^>": None,

		"<Ctrl-Shift-b>": "bookmark-list --tab",
		"<Ctrl-Shift-h>": "history --tab",
		"<Ctrl-Shift-a>": "tab-select",

		"<Ctrl-a>": None, # select all
		"<Ctrl-b>": None,
		"<Ctrl-c>": None, # copy

		"<Ctrl-d>": "scroll-page 0 0.5",

		"<Ctrl-e>": None,

		"<Ctrl-f>": "cmd-set-text /",

		"<Ctrl-g>": None,

		"<Ctrl-h>": "tab-move -",

		"<Ctrl-i>": None,
		"<Ctrl-j>": None,
		"<Ctrl-k>": None,

		"<Ctrl-l>": "tab-move +",

		"<Ctrl-m>": None,

		# "<Ctrl-n>": "open -w",
		# "<Ctrl-Shift-n>": "open --private",

		"<Ctrl-o>": None,
		"<Ctrl-p>": None,
		"<Ctrl-Alt-p>": None,

		# "<Ctrl-q>": "quit",

		"<Ctrl-r>": None,

		# "<Ctrl-s>": "stop",

		"<Ctrl-t>": "open --tab",
		"<Ctrl-Shift-t>": None,

		"<Ctrl-u>": "scroll-page 0 -0.5",

		"<Ctrl-v>": None, # paste

		# "<Ctrl-w>": "tab-close",
		# "<Ctrl-Shift-w>": "close",

		"<Ctrl-x>": None, # cut
		"<Ctrl-y>": None, # redo
		"<Ctrl-z>": None, # undo

		"<Alt-d>": "set colors.webpage.darkmode.enabled true",
		"<Alt-l>": "set colors.webpage.darkmode.enabled false",

		"<Alt-b>": "spawn --userscript bw",
		"<Alt-p>": "spawn --userscript bw --password-only",
		"<Alt-u>": "spawn --userscript bw --username-only",

		"$": "nop",
		"~": "nop",

		"@": "nop",
		"^": "nop",

		"'": "nop",
		'"': "nop",

		";d": "hint links download",
		";h": "hint all hover",
		";i": "hint inputs",
		";m": "hint images",
		";o": "hint links fill :open {hint-url}",
		";to": "hint links fill :open --tab {hint-url}",
		";wo": "hint links fill :open --window {hint-url}",
		";Wo": "hint links fill :open --private {hint-url}",
		";y": "hint links yank",
		";Y": "hint links yank-primary",
		# ":": "cmd-set-text :",

		",": "nop",
		"<": "nop",

		# ".": "cmd-repeat-last",
		">": "nop",

		# "/": "cmd-set-text /",
		# "?": "cmd-set-text ?",

		"-": "nop",
		"_": "nop",

		"\\": "nop",
		"|": "nop",

		"a": "hint all",
		"A": "hint all tab-fg",
		"ta": "hint all tab-bg",
		"tA": "hint all tab-fg",
		"wa": "hint all window",
		"Wa": "hint all run :open --private {hint-url}",

		"b": "cmd-set-text --space :quickmark-load",
		"B": "cmd-set-text --space :quickmark-load --tab",
		"tb": "cmd-set-text --space :quickmark-load --tab",
		"wb": "cmd-set-text --space :quickmark-load --window",

		"C": "nop",
		"ct": "tab-only",
		"ch": "tab-only --next",
		"cl": "tab-only --prev",
		"cw": "window-only",

		"d": "scroll-page 0 0.5",
		"D": "nop",

		"e": "cmd-set-text :open {url:pretty}",
		"E": "edit-url",
		"te": "cmd-set-text :open --tab {url:pretty}",
		"tE": "edit-url --tab",
		"we": "cmd-set-text :open --window {url:pretty}",
		"We": "cmd-set-text :open --private {url:pretty}",
		"wE": "edit-url --window",
		"WE": "edit-url --private",

		"f": "hint links",
		"F": "hint links tab-fg",
		"tf": "hint links tab-bg",
		"tF": "hint links tab-fg",
		"wf": "hint links window",
		"Wf": "hint links run :open --private {hint-url}",

		"G": "scroll-to-perc",

		"h": "tab-prev",
		"H": "back",
		"th": "back --tab",
		"wh": "back --tab",

		# "i": "mode-enter insert",
		"I": "mode-enter passthrough",

		"j": "scroll down",
		"J": "scroll right",

		"k": "scroll up",
		"K": "scroll left",

		"l": "tab-next",
		"L": "forward",
		"tl": "forward --tab",
		"wl": "forward --window",

		"m": "cmd-set-text --space :bookmark-load",
		"M": "cmd-set-text --space :bookmark-load --tab",
		"tm": "cmd-set-text --space :bookmark-load --tab",
		"wm": "cmd-set-text --space :bookmark-load --window",

		"n": "search-next",
		"N": "search-prev",

		"o": "cmd-set-text --space :open",
		"O": "cmd-set-text --space :open --tab",
		"to": "cmd-set-text --space :open --tab",
		"wo": "cmd-set-text --space :open --window",
		"Wo": "cmd-set-text --space :open --private",

		"p": "open -- {clipboard}",
		"P": "open -- {primary}",
		"tp": "open --tab -- {clipboard}",
		"tP": "open --tab -- {primary}",
		"wp": "open --window -- {clipboard}",
		"wP": "open --window -- {primary}",
		"Wp": "open --private -- {clipboard}",
		"WP": "open --private -- {primary}",

		"q": "hint --rapid links tab-bg",
		"Q": "hint --rapid all tab-bg",

		"r": "reload",
		"R": "reload -f",

		"s": "tab-focus last",
		"S": "cmd-set-text --space --run-on-count :tab-focus",

		"T": "nop",
		"td": "tab-clone",
		"tg": "cmd-set-text --space :tab-give",
		"tt": "open --tab",
		"tu": "undo",

		"u": "scroll-page 0 -0.5",
		"U": "nop",

		"v": "mode-enter caret",
		"V": "mode-enter caret ;; selection-toggle --line",

		"wd": "tab-clone --window",
		"Wd": "tab-clone --private",
		"wt": "cmd-set-text --space :tab-take",
		"wu": "undo --window",
		"ww": "open --window",
		"Ww": "open --private",
		"WW": "open --private",

		"x": "tab-close",
		"X": "close",

		"Y": "nop",
		"yd": "yank domain",
		"yD": "yank domain --sel",
		"ym": "yank inline [{title}]({url:yank})",
		"yM": "yank inline [{title}]({url:yank}) --sel",
		"yp": "yank pretty-url",
		"yP": "yank pretty-url --sel",
		"yt": "yank title",
		"yT": "yank title --sel",
		"yy": "yank url",
		"yY": "yank url --sel",

		"z": "fullscreen ;; set statusbar.show always ;; set tabs.show multiple",
		"Z": "fullscreen --enter ;; set statusbar.show in-mode ;; set tabs.show switching",
	},
	"command": {
		"<Ctrl-j>": "command-history-next",
		"<Ctrl-k>": "command-history-prev",
	},
	"yesno": {
		"<Return>": "prompt-accept --save yes",
	},
	"insert": {
		"<Alt-b>": "spawn --userscript bw",
		"<Alt-p>": "spawn --userscript bw --password-only",
		"<Alt-u>": "spawn --userscript bw --username-only",
	},
	"hint": {
		"<Ctrl-b>": None,
		"<Ctrl-f>": None,
		"<Ctrl-r>": None,
		"<Return>": None,
		"l": "mode-enter normal ;; tab-next",
	},
}
