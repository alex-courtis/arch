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

set cursorline
set hlsearch
set ignorecase
set nowrapscan
set smartcase
set title
set undofile

" vim is smart enough about setting background
if &term =~ "alacritty" 
	set term=xterm-256color
endif

set listchars=tab:>\ ,trail:-,nbsp:+,space:·

