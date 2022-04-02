syntax on

" these are nvim defaults
set autoread
set formatoptions+=j
set hlsearch
set showcmd
set listchars=trail:·,tab:>\ ,eol:¬
map	Y	y$

" default $TERM -> ttymouse, possibly via terminfo database
" st -> xterm
" st-256color -> xterm
" tmux -> xterm
" xterm -> sgr
" xterm-256color -> sgr
if ($TERM =~ 'alacritty' || $TERM =~ 'st' || $TERM =~ 'tmux')
	set ttymouse=sgr
endif

" let the colorscheme set the (default light) background
set background=


let &rtp.=",~/.config/nvim"
runtime init.vim


" unnamedplus: yank etc. uses the + register, synced with XA_CLIPBOARD
" autoselect: visual selections go to * register, synced with XA_PRIMARY
set clipboard=unnamedplus,autoselect,exclude:cons\|linux

" vim cannot handle these escape mappings
nunmap <Esc>
let g:NERDTreeMapQuit = 'q'

set notermguicolors

