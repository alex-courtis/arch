settings.focusOnSaved = false

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

api.Hints.setCharacters('aoeuipyqx');

// ace editor
api.aceVimMap(';', ':', 'normal');

