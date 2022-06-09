// settings.focusOnSaved = false
settings.tabsThreshold = 99;
settings.tabsMRUOrder = false;

// ace editor
api.aceVimMap(';', ':', 'normal');

api.Hints.setCharacters('aoeuipyqx');

var except_map = [
	// unchanged defaults
	'<Ctrl-i>',
	'?', '/', ':',
	'd', 'u',
	'f',
	'gg', 'G',
	'i', 'I',
	'j', 'k',
	'n', 'N',
	'r',
	'T',
	'yy',
	'zi', 'zo', 'zr',
];
function map(new_keystroke, old_keystroke, domain, new_annotation) {
	api.map(new_keystroke, old_keystroke, domain, new_annotation);
	except_map.push(new_keystroke);
}
function mapkey(keys, annotation, jscode, options) {
	api.mapkey(keys, annotation, jscode, options);
	except_map.push(keys);
}

// toggle SK
map('<Ctrl-s>', '<Alt-s>');

// passthrough
map('<Ctrl-a>', '<Alt-i>');

// toggle PDF
map('<Ctrl-p>', ';s');

// back/forwards
map('<Space><Backspace>', 'S');
map('<Backspace><Backspace>', 'S');
map('<Backspace><Space>', 'D');
map('<Space><Space>', 'D');

// tab move left/right
map('H', '<<');
map('L', '>>');

// scroll left/right
map('<', 'h');
map('>', 'l');

// tab left/right
map('h', 'E');
map('l', 'R');

// other tabs close
map('C', 'gxx');

// additional down/up
map('<Ctrl-d>', 'd');
map('<Ctrl-u>', 'u');

// open link in new tab
map('F', 'af');

// new tab
map('_', 't');
map('t', 'on');

// open url
map('o', 'go');
map('O', '_');
api.unmap('_');

// move tab to another window
map('m', 'W');
mapkey('M', '#3Move current tab to a new window', function() {
	api.RUNTIME('moveToWindow', { windowId: -1 });
});

// edit url
map('v', ';U');
map('V', ';u');

// close / restore tab
map('q', 'x');
map('Q', 'X');

// omnibar page
api.cmap('<Ctrl-d>', '<Ctrl-.>');
api.cmap('<Ctrl-u>', '<Ctrl-,>');

// open bookmarks
mapkey('b', '#8Open a bookmark in current tab', function() {
	api.Front.openOmnibar(({type: "Bookmarks", tabbed: false}));
});
mapkey('B', '#8Open a bookmark in new tab', function() {
	api.Front.openOmnibar(({type: "Bookmarks", tabbed: true}));
});

// open search d with s and S; clobbers all the unwanted s prefixes
mapkey('s', '#6Duck Duck Go', function() {
	api.Front.openOmnibar(({type: "SearchEngine", extra: 'du', tabbed: false}));
});
mapkey('S', '#6Duck Duck Go', function() {
	api.Front.openOmnibar(({type: "SearchEngine", extra: 'du', tabbed: true}));
});

// open url from clipboard
mapkey('p', '#7Open link from clipboard in current tab', function() {
	api.Clipboard.read(function(response) {
		window.location.href = response.data;
	});
});
mapkey('P', '#7Open link from clipboard in new tab', function() {
	api.Clipboard.read(function(response) {
		api.tabOpenLink(response.data);
	});
});

// create search alias with e and E prefixes
api.unmap('e');
api.unmap('E');
function createSearch(alias, prompt, search_url, suggestion_url, callback_to_parse_suggestion) {
	api.addSearchAlias(alias, prompt, search_url, suggestion_url, callback_to_parse_suggestion);
	mapkey('e' + alias, '#6' + prompt, () => {
		api.Front.openOmnibar({type: 'SearchEngine', extra: alias, tabbed: false});
	});
	mapkey('E' + alias, '#6' + prompt, () => {
		api.Front.openOmnibar({type: 'SearchEngine', extra: alias, tabbed: true});
	});
}

// clear all default search aliases
api.removeSearchAlias('g');
api.removeSearchAlias('d');
api.removeSearchAlias('b');
api.removeSearchAlias('e');
api.removeSearchAlias('w');
api.removeSearchAlias('s');
api.removeSearchAlias('h');
api.removeSearchAlias('y');

// search aliases
createSearch('ap', 'Arch Packages', 'https://archlinux.org/packages/?q=');
createSearch('au', 'AUR Packages', 'https://aur.archlinux.org/packages?K=');
createSearch('aw', 'Arch Wiki', 'https://wiki.archlinux.org/index.php?search=');
createSearch('dw', 'Dark Souls Wiki', 'https://darksouls.fandom.com/wiki/Special:Search?query=');
createSearch('ga', 'go', 'http://go/');
createSearch('sd', 'Steam DB', 'https://steamdb.info/search/?q=');
createSearch('ss', 'Steam Store', 'https://store.steampowered.com/search/?term=');
createSearch('du', 'Duck Duck Go', 'https://duckduckgo.com/?q=', 's', 'https://duckduckgo.com/ac/?q=', function(response) {
	var res = JSON.parse(response.text);
	return res.map(function(r){
		return r.phrase;
	});
});
createSearch('go', 'Google', 'https://www.google.com/search?q=', 's', 'https://www.google.com/complete/search?client=chrome-omni&gs_ri=chrome-ext&oit=1&cp=1&pgcl=7&q=', function(response) {
	var res = JSON.parse(response.text);
	return res[1];
});
createSearch('wi', 'Wikipedia', 'https://en.wikipedia.org/wiki/', 's', 'https://en.wikipedia.org/w/api.php?action=opensearch&format=json&formatversion=2&namespace=0&limit=40&search=', function(response) {
	return JSON.parse(response.text)[1];
});
createSearch('yo', 'YouTube', 'https://www.youtube.com/results?search_query=', 's',
	'https://clients1.google.com/complete/search?client=youtube&ds=yt&callback=cb&q=', function(response) {
		var res = JSON.parse(response.text.substr(9, response.text.length-10));
		return res[1].map(function(d) {
			return d[0];
		});
	});

// unmap defaults
api.unmapAllExcept(except_map);
api.iunmap(':');
api.iunmap('<Ctrl-u>');

// no api for visual unmap
api.vunmap('$');
api.vunmap('(');
api.vunmap(')');
api.vunmap('*');
api.vunmap(',');
api.vunmap('0');
api.vunmap(';');
api.vunmap('<Ctrl-d>');
api.vunmap('<Ctrl-u>');
api.vunmap('<Enter>');
api.vunmap('<Shift-Enter>');
api.vunmap('b');
api.vunmap('e');
api.vunmap('f');
api.vunmap('F');
api.vunmap('G');
api.vunmap('gg');
api.vunmap('gr');
api.vunmap('h');
api.vunmap('j');
api.vunmap('k');
api.vunmap('l');
api.vunmap('o');
api.vunmap('p');
api.vunmap('q');
api.vunmap('t');
api.vunmap('V');
api.vunmap('w');
api.vunmap('zz');
api.vunmap('{');
api.vunmap('}');

// omnibar; no api for command unmap 
api.cmap('<Ctrl-.>', '');
api.cmap('<Ctrl-,>', '');
api.cmap('<Ctrl-v>', '');
api.cmap('<Ctrl-m>', '');
api.cmap('<Ctrl-D>', '');
api.cmap('<Ctrl-r>', '');
api.cmap("<Ctrl-'>", '');
api.cmap('<Ctrl-n>', '');
api.cmap('<Ctrl-p>', '');

