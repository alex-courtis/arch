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

let &titlestring="VIM"
if ($ALACRITTY_THEME != "")
	let &titlestring.=" {" . $ALACRITTY_THEME . "}"
endif

set number relativenumber

" Use only the terminal's carefully selected ANSI colours for syntax hl.
" I am still permitted to use colours outside of that range.
if &t_Co > 16
	set t_Co=16
endif
set background=dark

highlight LineNrBelow ctermfg=8
highlight LineNrAbove ctermfg=8

highlight MatchParen ctermbg=8

cmap W w


" vim-gitgutter
"
set updatetime=250

" ansi colours to match git diff
highlight GitGutterAdd    ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1


" editorconfig
"
highlight ColorColumn ctermbg=234
let g:EditorConfig_max_line_indicator = 'line'


" xterm-color-table
"
let g:XtermColorTableDefaultOpen = 'edit'

