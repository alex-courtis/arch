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

let &titlestring='%f %m%r ' . $TERMINAL_THEME


" bindings
"
nmap <F5>	:NERDTreeToggle<CR>
nmap <F7>	<Plug>(GitGutterNextHunk)
nmap <S-F7>	<Plug>(GitGutterPrevHunk)
nmap <F8>	:TagbarToggle<CR>

" plugins now, so that changes such as t_Co are taken into account
"
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'guns/xterm-color-table.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'wincent/terminus'
call vundle#end()


" Does not change terminal colours, just the syntax to ANSI 16 colour mappings.
"
colorscheme base16-default-dark


" vim-gitgutter
"
set updatetime=250


" editorconfig
"
let g:EditorConfig_max_line_indicator='fill'


" airline
"
set noshowmode

" Just maps airline to the ANSI 16.
" base16-vim-airline-themes doesn't colour the whole of airline.
let g:airline_theme='base16'

let g:airline_powerline_fonts=0

let g:airline_section_x = '%{airline#extensions#tagbar#currenttag()}'
let g:airline_section_y = '%{airline#parts#filetype()}'
let g:airline_section_z = '%3v %#__accent_bold#%3l%#__restore__# / %L %3P'

