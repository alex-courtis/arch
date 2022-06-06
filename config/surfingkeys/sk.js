settings.focusOnSaved = false

var engine_prefix_this_tab = 'e';
api.unmap('e');
var engine_prefix_new_tab = 'E';
api.unmap('E');

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

// open url - current tab
api.map('O', 't');
api.unmap('t');

// move tab to another window
api.map('w', 'W');
api.unmap('W');

// new tab
api.map('t', 'on');
api.unmap('on');

// open url - new tab
api.map('o', 'go');
api.unmap('go');

// open bookmarks
api.mapkey('b', '#8Open a bookmark in current tab', function() {
	api.Front.openOmnibar(({type: "Bookmarks", tabbed: false}));
});
api.mapkey('B', '#8Open a bookmark in new tab', function() {
	api.Front.openOmnibar(({type: "Bookmarks", tabbed: true}));
});

// open search d with s and S; clobbers all the unwanted s prefixes
api.mapkey('s', '#8Duck Duck Go', function() {
	api.Front.openOmnibar(({type: "SearchEngine", extra: 'du', tabbed: false}));
});
api.mapkey('S', '#8Duck Duck Go', function() {
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

function createSearch(alias, prompt, search_url, suggestion_url, callback_to_parse_suggestion) {
	api.addSearchAlias(alias, prompt, search_url, suggestion_url, callback_to_parse_suggestion);
	api.unmap('o' + alias);
	api.unmap('s' + alias);
	api.mapkey(engine_prefix_this_tab + alias, '#8' + prompt, () => {
		api.Front.openOmnibar({type: 'SearchEngine', extra: alias, tabbed: false});
	});
	api.mapkey(engine_prefix_new_tab + alias, '#8' + prompt, () => {
		api.Front.openOmnibar({type: 'SearchEngine', extra: alias, tabbed: true});
	});
}

// real search aliases
createSearch('du', 'Duck Duck Go', 'https://duckduckgo.com/?q=', 's', 'https://duckduckgo.com/ac/?q=', function(response) {
	var res = JSON.parse(response.text);
	return res.map(function(r){
		return r.phrase;
	});
});
createSearch('wi', 'Wikipedia', 'https://en.wikipedia.org/wiki/', 's', 'https://en.wikipedia.org/w/api.php?action=opensearch&format=json&formatversion=2&namespace=0&limit=40&search=', function(response) {
	return JSON.parse(response.text)[1];
});
createSearch('ap', 'Arch Packages', 'https://archlinux.org/packages/?q=');
createSearch('aw', 'Arch Wiki', 'https://wiki.archlinux.org/index.php?search=');
createSearch('au', 'AUR Packages', 'https://aur.archlinux.org/packages?K=');
createSearch('sd', 'Steam DB', 'https://steamdb.info/search/?q=');
createSearch('ss', 'Steam Store', 'https://store.steampowered.com/search/?term=');
createSearch('dw', 'Dark Souls Wiki', 'https://darksouls.fandom.com/wiki/Special:Search?query=');

// ace editor
api.aceVimMap(';', ':', 'normal');

