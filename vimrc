syntax on

" unnamedplus: yank etc. uses the + register, synced with XA_CLIPBOARD
" autoselect: visual selections go to * register, synced with XA_PRIMARY
set clipboard=unnamedplus,autoselect,exclude:cons\|linux

" these are nvim defaults
set autoread
set formatoptions+=j
set hlsearch
set showcmd
set listchars=trail:·,tab:>\ ,eol:¬

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


" vim cannot handle this
nunmap <Esc>

" sometimes terminal sends C-Space as Nul, so map it
ino	<expr>	<Nul>		amc#omni#begin()

" this is undesirably underlined
function ColorSchemeCustVim()
	highlight CursorLineNr cterm=NONE ctermfg=7
endfunction
autocmd ColorScheme * call ColorSchemeCustVim()

" nvim automatically does this
execute "colorscheme " . colors_name

