runtime! defaults.vim

" unnamedplus: yank etc. uses the + register: XA_PRIMARY
" autoselect: visual selections go to * register: XA_SECONDARY
set clipboard=unnamedplus,autoselect,exclude:cons\|linux

set hlsearch

set ignorecase
set smartcase

" use only the terminal's carefully selected 16 colours
set t_Co=16

set background=dark
