runtime! defaults.vim

" unnamedplus: yank etc. uses the + register, synced with XA_CLIPBOARD
" autoselect: visual selections go to * register, synced with XA_PRIMARY
if has('nvim')
	set clipboard+=unnamedplus
else
	set clipboard=unnamedplus,autoselect,exclude:cons\|linux
endif

set ignorecase
set smartcase

set hlsearch
set nowrapscan

set autoread
set autowriteall

set listchars=trail:·,tab:>\ ,eol:¬

set formatoptions+=j

set number relativenumber

set cursorline

" longest:full is necessary as :help does not obey longest
set wildmode=longest:full,full

" let the colorscheme set the (default light) background
set background=

" alacritty, st, xterm and tmux all talk sgr
" terminus automatically sets it when under tmux
" vim hardcodes st to 'xterm' and xterm to 'sgr'
" sgr is desirable as one of its side effects is the ability to handle modified F1-F4
if !has('nvim') && ($TERM =~ 'alacritty' || $TERM =~ 'st-')
	set ttymouse=sgr
endif

" vim needs to be told explicitly listen for modified function keys
execute 'set <xF1>=[1;*P'
execute 'set <xF2>=[1;*Q'
execute 'set <xF3>=[1;*R'
execute 'set <xF4>=[1;*S'
execute 'set  <F5>=[15;*~'
execute 'set  <F6>=[17;*~'
execute 'set  <F7>=[18;*~'
execute 'set  <F8>=[19;*~'
execute 'set  <F9>=[20;*~'
execute 'set <F10>=[21;*~'
execute 'set <F11>=[23;*~'
execute 'set <F12>=[24;*~'


" don't modify the scroll amounts with modifiers
no 	<S-ScrollWheelDown>	<ScrollWheelDown>
no 	<S-ScrollWheelUp>	<ScrollWheelUp>
no 	<S-ScrollWheelLeft>	<ScrollWheelLeft>
no 	<S-ScrollWheelRight>	<ScrollWheelRight>
no 	<C-ScrollWheelDown>	<ScrollWheelDown>
no 	<C-ScrollWheelUp>	<ScrollWheelUp>
no 	<C-ScrollWheelLeft>	<ScrollWheelLeft>
no 	<C-ScrollWheelRight>	<ScrollWheelRight>


" debugging
"
function AMCLog(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction
"
" debugging


" mappings
"
nno 	; 	:
vno 	; 	:
nno 	q; 	q:
vno 	q; 	q:
nno 	@; 	@:
vno 	@; 	@:
nno 	<C-w>; 	<C-w>:
vno 	<C-w>; 	<C-w>:

nno	<silent>	<Leader>a	:b #<CR>

nno	<silent>	<Leader>,	:call NERDTreeSmartToggle()<CR>
nno	<silent>	<Leader>o	:call NERDTreeSmartFocus()<CR>
nno	<silent>	<Leader>q	:call NERDTreeSmartFind()<CR>

nno	<silent>	<Leader>e	:ToggleBufExplorer<CR>

" TODO do not allow from nerdtree as is messes up the windows
nno	<silent>	<Leader>p	:TagbarToggle<CR>
nno	<silent>	<Leader>u	:TagbarOpen fj<CR>

nmap	<silent>	<Leader>j	<Plug>(GitGutterNextHunk)
nmap	<silent>	<Leader>k	<Plug>(GitGutterPrevHunk)

nno	<silent>	<Leader>f	gg=G``

nno     <silent>        <Leader>d       :BD<cr>

nno	<silent>	<Leader>hc	:call gitgutter#hunk#close_hunk_preview_window()<CR>

nno	<silent>	<Leader>c	:call settagstack(win_getid(), {'items' : []})<CR>
nno	<silent>	<Leader>r	:tp<CR>
nno	<silent>	<Leader>t	<C-]>
nno	<silent>	<Leader>n	:tn<CR>

nno	<silent>	<Leader>s	:nohlsearch<CR>

nno	<silent>	<Leader>m	:make<CR>

" common
cno		<C-j>	<Down>
cno		<C-k>	<Up>
"
" mappings


" omnicompletion
"   inspired by https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"
set completeopt=menuone,longest

" sometimes terminal sends C-Space as Nul, so map it
ino	<expr>	<Nul>		OmniBegin()
ino	<expr>	<C-Space>	OmniBegin()
ino	<expr>	<C-n>		OmniNext()
ino	<expr>	<C-x><C-o>	OmniBegin()
ino	<expr>	<CR>		OmniMaybeSelectFirstAndAccept()
ino	<expr>	<Tab>		pumvisible() ? "\<C-n>" : "\<Tab>"
ino	<expr>	<S-Tab>		pumvisible() ? "\<C-p>" : "\<S-Tab>"

autocmd CompleteDone * call OmniEnd()

" turn off ignore case, as mixed case matches result in longest length 0
function! OmniBegin()
	set noignorecase
	return "\<C-x>\<C-o>\<C-n>"
endfunction

function! OmniNext()
	return "\<C-n>\<C-n>"
endfunction

" turn on ignore case
function! OmniEnd()
	set ignorecase
endfunction

function! OmniMaybeSelectFirstAndAccept()
	if pumvisible()
		let ci=complete_info()
		if !empty(ci) && !empty(ci.items)
			if ci.selected == -1
				return "\<C-n>\<C-y>"
			else
				return "\<C-y>"
			endif
		endif
	endif
	return "\<CR>"
endfunction
"
" omnicompletion


" quickfix
"
let ef_cmocha = "[   LINE   ] --- %f:%l:%m"
let ef_make = "make: *** [%f:%l:%m"
let &errorformat= ef_cmocha . "," . ef_make . "," . &errorformat
"
" quickfix


" airline
"
set noshowmode

let g:airline#extensions#searchcount#enabled = 0

let airline_section_x=''
let airline_section_y='%{airline#parts#filetype()}'
let airline_section_z='%2v %#__accent_bold#%3l%#__restore__#/%L'
let g:airline#extensions#whitespace#checks=['trailing', 'conflicts']
"
" airline


" bufexplorer
"
let g:bufExplorerDefaultHelp=0
let g:bufExplorerDisableDefaultKeyMapping=1
"
" bufexplorer


" editorconfig
"
let EditorConfig_max_line_indicator='line'
"
" editorconfig


" nerdtree
"
let NERDTreeMinimalUI=1

let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

set wildignore+=*.o,*.class
let NERDTreeRespectWildIgnore=1

autocmd StdinReadPre * let s:std_in=1

" Exit Vim if NERDTree is the only window remaining in the only tab.
" Fails ungracefully if there are more files to edit
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Start NERDTree when Vim is started without any arguments or stdin.
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree when Vim starts with single directory argument and focus it.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | execute 'NERDTreeFocus' | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

function! NERDTreeIsOpen()
	return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" listed buffer
" 'normal' buffer (buftype empty)
" buffers with a name
" not a known plugin which is yet set the above
function NERDTreeFindableBuf()
	return
				\ &buflisted &&
				\ strlen(&buftype) == 0 &&
				\ strlen(bufname()) != 0 &&
				\ (!exists('t:tagbar_buf_name') || bufname() != t:tagbar_buf_name) &&
				\ (!exists('t:NERDTreeBufName') || bufname() != t:NERDTreeBufName) &&
 				\ bufname() != 'gitgutter://hunk-preview' &&
				\ bufname() != '[BufExplorer]'
endfunction

" only findable files under cwd
function NERDTreeReveal()
	if bufname()[0] != "/" && NERDTreeFindableBuf()
		NERDTreeCWD
		wincmd p
		NERDTreeFind
		return 1
	else
		return 0
	endif
endfunction

function NERDTreeSmartToggle()
	if NERDTreeIsOpen()
		NERDTreeClose
	else
		NERDTree
		wincmd p
	endif
endfunction

function NERDTreeSmartFocus()
	if NERDTreeIsOpen()
		NERDTreeFocus
	elseif !NERDTreeReveal()
		NERDTree
	endif
endfunction

function NERDTreeSmartFind()
	if NERDTreeFindableBuf()
		NERDTreeFind
		wincmd p
	endif
endfunction

function NERDTreeSync()
	if NERDTreeIsOpen() && NERDTreeReveal()
		wincmd p
	endif
endfunction
autocmd BufEnter * call NERDTreeSync()
"
" nerdtree


" nerdtree-git-plugin
"
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
"
" nerdtree-git-plugin


" tagbar
"
let g:tagbar_compact=1
"
" tagbar


" vim-gitgutter
"
set updatetime=250
let g:gitgutter_close_preview_on_escape=1
"
" vim-gitgutter


" base16-vim
"
if (&t_Co >= 255)
	" base16 schemes use the bonus colours 17-21
	" see https://github.com/chriskempson/base16-shell
	let base16colorspace=256
endif
"
" base16-vim


" plugins as late as possible
"
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'qpkorr/vim-bufkill'
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-commentary'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'wincent/terminus'
Plugin 'Xuyuanp/nerdtree-git-plugin'
call vundle#end()
filetype plugin indent on
"
" plugins


" also selects the base16 vim-airline-theme
colorscheme base16-bright

" nvim does some more processing after this and sets things up well, apparently based on colorscheme
if !has('nvim')
	highlight CursorLineNr cterm=NONE ctermfg=7
endif

