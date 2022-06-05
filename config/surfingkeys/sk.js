settings.focusOnSaved = false

api.Hints.setCharacters('aoeuipyqx');

// back/forwards
api.map('<Space><Backspace>', 'S');
api.map('<Backspace><Backspace>', 'S');
api.unmap('S');
api.map('<Backspace><Space>', 'D');
api.map('<Space><Space>', 'D');
api.unmap('D');

// tab left/right
api.map('h', 'E');
api.unmap('E');
api.map('l', 'R');
api.unmap('R');

// tab move left/right
api.map('H', '<<');
api.unmap('<<');
api.map('L', '>>');
api.unmap('>>');

// scroll left/right
api.map('<', 'h');
api.map('>', 'l');

// other tabs close
api.map('C', 'gxx');

// additional down/up
api.map('<Ctrl-d>', 'd');
api.map('<Ctrl-u>', 'u');

// open link in new tab
api.map('F', 'af');

// open url
api.map('e', 'go');
api.unmap('go');
api.map('E', 't');

// move tab to another window
api.map('w', 'W');
api.unmap('W');

// new tab
api.map('t', 'on');
api.unmap('on');

// open bookmarks
api.mapkey('b', '#8Open a bookmark in current tab', function() {
	api.Front.openOmnibar(({type: "Bookmarks", tabbed: false}));
});
api.mapkey('B', '#8Open a bookmark in new tab', function() {
	api.Front.openOmnibar(({type: "Bookmarks", tabbed: true}));
});

// open search d with s and S; clobbers all the unwanted s prefixes
api.mapkey('s', '#8Open search with alias du in current tab', function() {
	api.Front.openOmnibar(({type: "SearchEngine", extra: 'du', tabbed: false}));
});
api.mapkey('S', '#8Open search with alias du in new tab', function() {
	api.Front.openOmnibar(({type: "SearchEngine", extra: 'du', tabbed: true}));
});

// open url from clipboard
api.mapkey('p', '#7Open link from clipboard in current tab', function() {
	api.Clipboard.read(function(response) {
		window.location.href = response.data;
	});
});
api.mapkey('P', '#7Open link from clipboard in new tab', function() {
	api.Clipboard.read(function(response) {
		api.tabOpenLink(response.data);
	});
});

// clear most search aliases
api.removeSearchAlias('e');
api.removeSearchAlias('d');
api.removeSearchAlias('b');
api.removeSearchAlias('s');
api.removeSearchAlias('h');
api.removeSearchAlias('w');

// real search aliases
// TODO make untabbed, add O prefix for tabbed
api.addSearchAlias('du', 'duckduckgo', 'https://duckduckgo.com/?q=', 's', 'https://duckduckgo.com/ac/?q=', function(response) {
	var res = JSON.parse(response.text);
	return res.map(function(r){
		return r.phrase;
	});
});
api.addSearchAlias('wi', 'wikipedia', 'https://en.wikipedia.org/wiki/', 's', 'https://en.wikipedia.org/w/api.php?action=opensearch&format=json&formatversion=2&namespace=0&limit=40&search=', function(response) {
	return JSON.parse(response.text)[1];
});
api.addSearchAlias('ap', 'Arch Packages', 'https://www.archlinux.org/packages/?q=%s');
api.addSearchAlias('aw', 'Arch Wiki', 'https://wiki.archlinux.org/index.php?title=Special:Search&search=%s');
api.addSearchAlias('au', 'AUR Packages', 'https://aur.archlinux.org/packages/?O=0&K=%s');
api.addSearchAlias('sd', 'Steam DB', 'https://steamdb.info/search/?a=app&q=%s');
api.addSearchAlias('ss', 'Steam Store', 'https://store.steampowered.com/search/?snr=1_4_4__12&term=%s');
api.addSearchAlias('dw', 'Dark Souls Wiki', 'https://darksouls.fandom.com/wiki/Special:Search?query=%s&scope=internal&navigationSearch=true');
api.mapkey('odw', '#8Open Search with alias dw', () => {
	api.Front.openOmnibar({type: "SearchEngine", extra: 'dw', tabbed: false});
});

// ace editor
api.aceVimMap(';', ':', 'normal');

