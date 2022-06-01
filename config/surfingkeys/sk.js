settings.focusOnSaved = true

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

// search aliases, changing w from bing to wikip
api.map('ow', 'oe');
api.unmap('oe');
api.map('sw', 'se');
api.unmap('se');
api.removeSearchAlias('b');
api.removeSearchAlias('s');
api.removeSearchAlias('h');

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
api.mapkey('b', '#8Open a bookmark in current tab', function() { api.Front.openOmnibar(({type: "Bookmarks", tabbed: false})); });
api.mapkey('B', '#8Open a bookmark in new tab', function() { api.Front.openOmnibar(({type: "Bookmarks", tabbed: true})); });

// open search d with s and S
api.mapkey('s', '#8Open search with alias d in current tab', function() { api.Front.openOmnibar(({type: "SearchEngine", extra: 'd', tabbed: false})); });
api.mapkey('S', '#8Open search with alias d in new tab', function() { api.Front.openOmnibar(({type: "SearchEngine", extra: 'd', tabbed: true})); });

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

// ace editor
api.aceVimMap(';', ':', 'normal');

