runtime! defaults.vim

" unnamedplus: yank etc. uses the + register, synced with XA_CLIPBOARD
" autoselect: visual selections go to * register, synced with XA_PRIMARY
set clipboard=unnamedplus,autoselect,exclude:cons\|linux

set hlsearch
set ignorecase
set smartcase
set nowrapscan

set listchars=trail:·,tab:>\ ,eol:¬

set formatoptions+=j

set laststatus=2

set number relativenumber

" ANSI colours only; more colours can still be explicitly selected.
if &t_Co > 16
	set t_Co=16
endif
set background=dark

highlight LineNrBelow ctermfg=8
highlight LineNrAbove ctermfg=8

highlight MatchParen ctermbg=8


" vim-gitgutter
"
set updatetime=250

" ansi colours to match git diff
highlight SignColumn      ctermbg=NONE
highlight GitGutterAdd    ctermbg=NONE ctermfg=2
highlight GitGutterChange ctermbg=NONE ctermfg=3
highlight GitGutterDelete ctermbg=NONE ctermfg=1


" editorconfig
"
highlight ColorColumn ctermbg=3
let g:EditorConfig_max_line_indicator="exceeding"


" xterm-color-table
"
let g:XtermColorTableDefaultOpen="edit"


" airline
"
let g:airline_powerline_fonts=1
if ($ALACRITTY_THEME != "")
	let &titlestring="%F %m%r {" . $ALACRITTY_THEME . "}"
else
	let &titlestring="%F %m%r"
endif


" vundle at the end, so it picks up customisations from above e.g. t_Co
"
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'guns/xterm-color-table.vim'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'wincent/terminus'

call vundle#end()
filetype plugin indent on

