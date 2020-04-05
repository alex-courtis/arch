runtime! defaults.vim

" unnamedplus: yank etc. uses the + register: XA_PRIMARY
" autoselect: visual selections go to * register: XA_SECONDARY
set clipboard=unnamedplus,autoselect,exclude:cons\|linux

set hlsearch

set ignorecase
set smartcase

" use only the terminal's carefully selected ANSI colours
if $TERM =~? "256color"
	set t_Co=16
endif

set background=dark

set listchars+=eol:¬
set listchars+=tab:>·
