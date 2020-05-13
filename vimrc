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

set number relativenumber

" unadjusted ANSI base16 colours only
if &t_Co > 16 && !&diff
	set t_Co=16
endif
set background=

if ($TERMINAL_THEME != "")
	let &titlestring="%f %m%r {" . $TERMINAL_THEME . "}"
else
	let &titlestring="%f %m%r"
endif


" plugins now, so that changes such as t_Co are taken into account
"
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/base16-vim'
Plugin 'dawikur/base16-vim-airline-themes'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'guns/xterm-color-table.vim'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'wincent/terminus'
call vundle#end()


" Base16 scheme doesn't alter the 16 ANSI terminal colours, only the syntax
" highlighting group mappings to ANSI colours.
" It does, however, implicitly load the matching airline theme which maps
" the airline colours back to ANSI.
"
colorscheme base16-default-dark


" vim-gitgutter
"
set updatetime=250

" ansi colours to match git diff
"highlight SignColumn      ctermbg=NONE
"highlight GitGutterAdd    ctermbg=NONE ctermfg=2
"highlight GitGutterChange ctermbg=NONE ctermfg=3
"highlight GitGutterDelete ctermbg=NONE ctermfg=1


" editorconfig
"
highlight ColorColumn ctermbg=3
let g:EditorConfig_max_line_indicator="exceeding"


" airline
"
set noshowmode

let g:airline_powerline_fonts=1

let g:airline_section_x = '%{airline#extensions#tagbar#currenttag()}'
let g:airline_section_y = '%{airline#parts#filetype()}'
let g:airline_section_z = '%3v %#__accent_bold#%3l%#__restore__# / %L %3P'

