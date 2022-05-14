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


" mapping overrides
for s:leader in [ "\<Space>", "\<BS>", ]
let mapleader=s:leader
nm	<silent>	<Leader>;	:call amc#nt#smartFind()<CR>
nm	<silent>	<Leader>a	:call amc#nt#smartFocus()<CR>
unmap			<Leader>,
endfor


" nerdtree
set wildignore+=*.o,*.class
let NERDTreeRespectWildIgnore = 1
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeMapQuit = '<Esc>'
autocmd BufEnter * call amc#nt#sync()
autocmd VimEnter * call amc#nt#startup()

" nerdtree-git-plugin
let g:NERDTreeGitStatusDirDirtyOnly = 0
let g:NERDTreeGitStatusIndicatorMapCustom = {
			\ "Modified"  : "~",
			\ "Staged"    : "+",
			\ "Untracked" : "u",
			\ "Renamed"   : "r",
			\ "Unmerged"  : "*",
			\ "Deleted"   : "d",
			\ "Dirty"     : "x",
			\ "Clean"     : "c",
			\ 'Ignored'   : 'i',
			\ "Unknown"   : "?"
			\ }


" unnamedplus: yank etc. uses the + register, synced with XA_CLIPBOARD
" autoselect: visual selections go to * register, synced with XA_PRIMARY
set clipboard=unnamedplus,autoselect,exclude:cons\|linux

" vim cannot handle these escape mappings
nunmap <Esc>
let g:NERDTreeMapQuit = 'q'

set notermguicolors

