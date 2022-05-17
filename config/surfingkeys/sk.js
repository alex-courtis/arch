settings.focusOnSaved = true

// back/forwards
api.map('<Space><Backspace>', 'S');
api.map('<Backspace><Backspace>', 'S');
api.unmap('S');
api.map('<Backspace><Space>', 'D');
api.map('<Space><Space>', 'D');
api.unmap('D');

// scroll left/right
api.map('<', 'h')
api.map('>', 'l')

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

// overwrite all sX
api.map('s', 'od')

// open in new tab
api.map('F', 'gf')

// move tab to another window
api.map('w', 'W')

// open bookmarks
api.mapkey('b', '#8Open a bookmark in current tab', function() { api.Front.openOmnibar(({type: "Bookmarks", tabbed: false})); });
api.mapkey('B', '#8Open a bookmark in new tab', function() { api.Front.openOmnibar(({type: "Bookmarks", tabbed: true})); });

api.Hints.setCharacters('aoeuipyqx');

// ace editor
api.aceVimMap(';', ':', 'normal');

