settings.tabsThreshold = 99;
settings.tabsMRUOrder = false;
settings.focusFirstCandidate = true
settings.defaultSearchEngine = 'd'

// ace editor
api.aceVimMap(';', ':', 'normal');

api.Hints.setCharacters('aoeuidhtnspyfgcrlqjkxbmwvz');

var except_map = [
  // unchanged defaults
  '<Ctrl-i>',
  '<Esc>',
  '?', '/',
  'd', 'u',
  'f',
  'gg', 'G',
  'i', 'I',
  'j', 'k',
  'n', 'N',
  'r',
  'T',
  'yy',
  // remapping unreliable
  '<Alt-s>',
  '<Alt-i>',
];

function map(new_keystroke, old_keystroke, domain, new_annotation) {
  api.map(new_keystroke, old_keystroke, domain, new_annotation);
  except_map.push(new_keystroke);
}

function mapkey(keys, annotation, jscode, options) {
  api.mapkey(keys, annotation, jscode, options);
  except_map.push(keys);
}

// settings
map('<Alt-e>', ';e');

// toggle PDF
map('<Alt-p>', ';s');

// back/forwards
map('<Space><Backspace>', 'S');
map('<Backspace><Backspace>', 'S');
map('<Backspace><Space>', 'D');
map('<Space><Space>', 'D');

// new tab
map('t', 'on');

// close current tab
map('q', 'x');

// close other tabs all/left/right
map('ca', 'gxx');
map('ch', 'gx0');
map('cl', 'gx$');

// tab move left/right
map('H', '<<');
map('L', '>>');

// scroll left/right
map('<', 'h');
map('>', 'l');

// tab left/right
map('h', 'E');
map('l', 'R');

// additional down/up
map('<Ctrl-d>', 'd');
map('<Ctrl-u>', 'u');

// open link in new tab
map('F', 'af');

// move tab to another window
map('m', 'W');
mapkey('M', '#3Move current tab to a new window', function() {
  api.RUNTIME('moveToWindow', {
    windowId: -1
  });
});

// new windows
mapkey('w', '#8Open window', function() {
  api.RUNTIME('openWindow', {
    url: 'about:blank',
    incognito: false
  });
});
mapkey('W', '#8Open incognito window', function() {
  api.RUNTIME('openWindow', {
    url: 'about:blank',
    incognito: true
  });
});

// edit url
map('v', ';U');
map('V', ';u');

// omnibar page
api.cmap('<Ctrl-d>', '<Ctrl-.>');
api.cmap('<Ctrl-u>', '<Ctrl-,>');

// omnibar url
mapkey('o', '#8Open a URL in current tab', function() {
  api.Front.openOmnibar({
    type: "URLs",
    tabbed: false
  });
});
mapkey('O', '#8Open a URL in new tab', function() {
  api.Front.openOmnibar({
    type: "URLs",
    tabbed: true
  });
});

// open bookmarks
mapkey('b', '#8Open a bookmark in current tab', function() {
  api.Front.openOmnibar(({
    type: "Bookmarks",
    tabbed: false
  }));
});
mapkey('B', '#8Open a bookmark in new tab', function() {
  api.Front.openOmnibar(({
    type: "Bookmarks",
    tabbed: true
  }));
});

// open search g with s and S; clobbers all the unwanted s prefixes
mapkey('s', '#6Duck Duck Go', function() {
  api.Front.openOmnibar(({
    type: "SearchEngine",
    extra: 'd',
    tabbed: false
  }));
});
mapkey('S', '#6Duck Duck Go', function() {
  api.Front.openOmnibar(({
    type: "SearchEngine",
    extra: 'd',
    tabbed: true
  }));
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

// visual click
api.vmap('f', '<Enter>');
api.vmap('F', '<Shift-Enter>');

// clear all default search aliases
api.removeSearchAlias('g');
api.removeSearchAlias('d');
api.removeSearchAlias('b');
api.removeSearchAlias('e');
api.removeSearchAlias('w');
api.removeSearchAlias('s');
api.removeSearchAlias('h');
api.removeSearchAlias('y');

// create search alias
api.unmap('e');
api.unmap('E');

function createSearch(prefix, alias, prompt, search_url, suggestion_url, callback_to_parse_suggestion) {
  api.addSearchAlias(alias, prompt, search_url, suggestion_url, callback_to_parse_suggestion);
  mapkey(prefix + alias, '#6' + prompt, () => {
    api.Front.openOmnibar({
      type: 'SearchEngine',
      extra: alias,
      tabbed: false
    });
  });
  mapkey(prefix.toUpperCase() + alias, '#6' + prompt, () => {
    api.Front.openOmnibar({
      type: 'SearchEngine',
      extra: alias,
      tabbed: true
    });
  });
}

// search aliases
createSearch('e', 'ap', 'Arch Packages', 'https://archlinux.org/packages/?q=');
createSearch('e', 'au', 'AUR Packages', 'https://aur.archlinux.org/packages?K=');
createSearch('e', 'aw', 'Arch Wiki', 'https://wiki.archlinux.org/index.php?search=');
createSearch('e', 'dw', 'Dark Souls', 'https://darksouls.fandom.com/wiki/Special:Search?query=');
createSearch('e', 'hi', 'hello issue', 'https://hello.atlassian.net/browse/');
createSearch('e', 'hs', 'hello search', 'https://hello.atlassian.net/wiki/search?text=');
createSearch('e', 'na', 'Nier Automata', 'https://nier.fandom.com/wiki/Special:Search?query=')
createSearch('e', 'ni', 'nvim-tree issue', 'https://github.com/nvim-tree/nvim-tree.lua/issues/')
createSearch('e', 'o', 'go', 'http://go/');
createSearch('e', 'pd', 'Proton DB', 'https://www.protondb.com/search?q=');
createSearch('e', 'rr', 'Risk Of Rain', 'https://riskofrain2.fandom.com/wiki/Special:Search?query=')
createSearch('e', 'sd', 'Steam DB', 'https://steamdb.info/instantsearch/?query=');
createSearch('e', 'ss', 'Steam Store', 'https://store.steampowered.com/search/?term=');

createSearch('e', 'd', 'Duck Duck Go', 'https://duckduckgo.com/?q=');
createSearch('e', 'g', 'Google', 'https://www.google.com/search?q=');
createSearch('e', 'wi', 'Wikipedia', 'https://en.wikipedia.org/w/index.php?search=');
createSearch('e', 'y', 'YouTube', 'https://www.youtube.com/results?search_query=');

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
api.vunmap('<Ctrl-Shift-Enter>');
api.vunmap('b');
api.vunmap('e');
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
api.vunmap('y');
api.vunmap('zb');
api.vunmap('zt');
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

// https://github.com/Foldex/surfingkeys-config/blob/master/themes.js
api.Visual.style('marks', 'background-color: #fda331; opacity: 0.5;'); // base0A
api.Visual.style('cursor', 'background-color: #6fb3d2; z-index: 2147483300;'); // base0D, one higher than surfingkeys_selection_mark
settings.theme = `
:root {
  --font: Monospace;
  --font-size: 14;

  /* base16-bright */
  --base00: #000000; /* Default Background */
  --base01: #303030; /* Lighter Background (Used for status bars) */
  --base02: #505050; /* Selection Background */
  --base03: #b0b0b0; /* Comments, Invisibles, Line Highlighting */
  --base04: #d0d0d0; /* Dark Foreground (Used for status bars) */
  --base05: #e0e0e0; /* Default Foreground, Caret, Delimiters, Operators */
  --base06: #f5f5f5; /* Light Foreground (Not often used) */
  --base07: #ffffff; /* Light Background (Not often used) */
  /* red */
  --base08: #fb0120; /* Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted */
  /* orange */
  --base09: #fc6d24; /* Integers, Boolean, Constants, XML Attributes, Markup Link Url */
  /* yellow */
  --base0A: #fda331; /* Classes, Markup Bold, Search Text Background */
  /* green */
  --base0B: #a1c659; /* Strings, Inherited Class, Markup Code, Diff Inserted */
  /* cyan */
  --base0C: #76c7b7; /* Support, Regular Expressions, Escape Characters, Markup Quotes */
  /* blue */
  --base0D: #6fb3d2; /* Functions, Methods, Attribute IDs, Headings */
  /* magenta */
  --base0E: #d381c3; /* Keywords, Storage, Selector, Markup Italic, Diff Changed */
  /* brown */
  --base0F: #be643c; /* Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?> */

  --fg: var(--base05);
  --bg: var(--base01);
  --bg-dark: var(--base01);
  --border: var(--base02);
  --main-fg: var(--base0D);
  --accent-fg: var(--base05);
  --info-fg: var(--base0C);
  --select: var(--base02);
}

/* ---------- Generic ---------- */
.sk_theme {
background: var(--bg);
color: var(--fg);
  background-color: var(--bg);
  border-color: var(--border);
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
}

input {
  font-family: var(--font);
  font-weight: var(--font-weight);
}

.sk_theme tbody {
  color: var(--fg);
}

.sk_theme input {
  color: var(--fg);
}

/* Hints */
#sk_hints .begin {
  color: var(--accent-fg) !important;
}

#sk_tabs .sk_tab {
  background: var(--bg-dark);
  border: 1px solid var(--border);
}

#sk_tabs .sk_tab_title {
  color: var(--fg);
}

#sk_tabs .sk_tab_url {
  color: var(--main-fg);
}

#sk_tabs .sk_tab_hint {
  background: var(--bg);
  border: 1px solid var(--border);
  color: var(--accent-fg);
}

.sk_theme #sk_frame {
  background: var(--bg);
  opacity: 0.2;
  color: var(--accent-fg);
}

/* ---------- Omnibar ---------- */
/* Uncomment this and use settings.omnibarPosition = 'bottom' for Pentadactyl/Tridactyl style bottom bar */
/* .sk_theme#sk_omnibar {
  width: 100%;
  left: 0;
} */

.sk_theme .title {
  color: var(--accent-fg);
}

.sk_theme .url {
  color: var(--main-fg);
}

.sk_theme .annotation {
  color: var(--accent-fg);
}

.sk_theme .omnibar_highlight {
  color: var(--accent-fg);
}

.sk_theme .omnibar_timestamp {
  color: var(--info-fg);
}

.sk_theme .omnibar_visitcount {
  color: var(--accent-fg);
}

.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: var(--bg-dark);
}

.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: var(--border);
}

.sk_theme #sk_omnibarSearchArea {
  border-top-color: var(--border);
  border-bottom-color: var(--border);
}

.sk_theme #sk_omnibarSearchArea input,
.sk_theme #sk_omnibarSearchArea span {
  font-size: var(--font-size);
}

.sk_theme .separator {
  color: var(--accent-fg);
}

/* ---------- Popup Notification Banner ---------- */
#sk_banner {
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
  background: var(--bg);
  border-color: var(--border);
  color: var(--fg);
  opacity: 0.9;
}

/* ---------- Popup Keys ---------- */
#sk_keystroke {
  background-color: var(--bg);
}

.sk_theme kbd .candidates {
  color: var(--info-fg);
}

.sk_theme span.annotation {
  color: var(--accent-fg);
}

/* ---------- Popup Translation Bubble ---------- */
#sk_bubble {
  background-color: var(--bg) !important;
  color: var(--fg) !important;
  border-color: var(--border) !important;
}

#sk_bubble * {
  color: var(--fg) !important;
}

#sk_bubble div.sk_arrow div:nth-of-type(1) {
  border-top-color: var(--border) !important;
  border-bottom-color: var(--border) !important;
}

#sk_bubble div.sk_arrow div:nth-of-type(2) {
  border-top-color: var(--bg) !important;
  border-bottom-color: var(--bg) !important;
}

/* ---------- Search ---------- */
#sk_status,
#sk_find {
  font-size: var(--font-size);
  border-color: var(--border);
}

.sk_theme kbd {
  background: var(--bg-dark);
  border-color: var(--border);
  box-shadow: none;
  color: var(--fg);
}

.sk_theme .feature_name span {
  color: var(--main-fg);
}

/* ---------- ACE Editor ---------- */
#sk_editor {
  background: var(--bg-dark) !important;
  height: 40% !important;
}

.ace_dialog-bottom {
  border-top: 1px solid var(--bg) !important;
}

.ace-chrome .ace_print-margin,
.ace_gutter,
.ace_gutter-cell,
.ace_dialog {
  background: var(--bg) !important;
}

.ace-chrome {
  color: var(--fg) !important;
}

.ace_gutter,
.ace_dialog {
  color: var(--fg) !important;
}

.ace_cursor {
  color: var(--fg) !important;
}

.normal-mode .ace_cursor {
  background-color: var(--fg) !important;
  border: var(--fg) !important;
  opacity: 0.7 !important;
}

.ace_marker-layer .ace_selection {
  background: var(--select) !important;
}

.ace_editor,
.ace_dialog span,
.ace_dialog input {
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
}
`;
