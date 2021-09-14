syntax on

" unnamedplus: yank etc. uses the + register, synced with XA_CLIPBOARD
" autoselect: visual selections go to * register, synced with XA_PRIMARY
set clipboard=unnamedplus,autoselect,exclude:cons\|linux

" these are nvim defaults
set autoread
set formatoptions+=j
set hlsearch
set listchars=trail:·,tab:>\ ,eol:¬

" alacritty, st, xterm and tmux all talk sgr
" terminus automatically sets it when under tmux
" vim hardcodes st to 'xterm' and xterm to 'sgr'
" sgr is desirable as one of its side effects is the ability to handle modified F1-F4
if ($TERM =~ 'alacritty' || $TERM =~ 'st-')
	set ttymouse=sgr
endif

" let the colorscheme set the (default light) background
set background=


source ~/.config/nvim/init.vim


" this is undesirably underlined
highlight CursorLineNr cterm=NONE ctermfg=7

