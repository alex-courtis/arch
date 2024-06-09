let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

scriptencoding utf-8
set encoding=utf-8

nm	;	:
vm	;	:
nm	q;	q:
vm	q;	q:
nm	@;	@:
vm	@;	@:
nm	<C-w>; 	<C-w>:
vm	<C-w>; 	<C-w>:
cm	<C-j>	<Down>
cm	<C-k>	<Up>

nm	<Space>x	:b#<CR>

syntax on

set clipboard=unnamedplus,autoselect
set cursorline
set hlsearch
set ignorecase
set number
set smartcase
set title
set undofile
set nowrapscan

" stick to 256, no base16 extensions
if stridx(&term, "linux") != 0
 	set term=xterm-256color
endif
set bg=dark

set listchars=tab:>\ ,trail:-,nbsp:+,space:·

hi! link CursorLine CursorColumn
hi! link CursorLineNr CursorColumn
hi! link LineNr CursorColumn
