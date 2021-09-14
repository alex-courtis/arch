" unnamedplus: yank etc. uses the + register, synced with X or wayland clipboard
set clipboard=unnamedplus

set ignorecase
set smartcase

set nowrapscan

set autowriteall

set number relativenumber

" let's try no cursorline for a while
" set cursorline

set mouse=a

" longest:full is necessary as :help does not obey longest
set wildmode=longest:full,full

set undofile

if !has('nvim')
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
endif


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

nno	<silent>	<Leader>;	:call NERDTreeSmartFind()<CR>
nno	<silent>	<Leader>a	:call NERDTreeSmartFocus()<CR>
nno	<silent>	<Leader>A	:NERDTreeClose<CR>

nmap	<silent>	<Leader>,	:GoHelp<CR>
nmap	<silent>	<Leader><	:helpclose<CR>
nno	<silent>	<Leader>o	:GoHome<CR>
nmap	<silent>	<Leader>q	:GoHome <Bar> belowright copen<CR>
nmap	<silent>	<Leader>Q	:cclose<CR>

nno	<silent>	<Leader>.	:cnext<CR>
nno	<silent>	<Leader>e	:GoHome <Bar> ToggleBufExplorer<CR>
nmap	<silent>	<Leader>j	<Plug>(GitGutterNextHunk)

nno	<silent>	<Leader>p	:cprev<CR>
nno	<silent>	<Leader>u	:b#<CR>
nmap	<silent>	<Leader>k	<Plug>(GitGutterPrevHunk)

nno	<silent>	<Leader>i	:GoHome <Bar> TagbarOpen fj<CR>
nno	<silent>	<Leader>I	:TagbarClose<CR>


nno	<silent>	<Leader>f	gg=G``

nno	<silent>	<Leader>hc	:call gitgutter#hunk#close_hunk_preview_window()<CR>
nno	<silent>	<Leader>m	:make<CR>
nno	<silent>	<Leader>M	:make clean<CR>

nno	<silent>	<Leader>c	:nohlsearch<CR>
nno	<silent>	<Leader>t	<C-]>
nno	<silent>	<Leader>T	:call settagstack(win_getid(), {'items' : []})<CR>

nno	<silent>	<Leader>n	:tn<CR>
nno	<silent>	<Leader>N	:tp<CR>
nno			<Leader>r	:%s/

" common
cno		<C-j>	<Down>
cno		<C-k>	<Up>
"
" mappings


" grep
"
set grepprg=ag\ --nogroup\ --nocolor

cabbrev ag silent grep!
"
" grep


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
let s:ef_cmocha = "[   LINE   ] --- %f:%l:%m,"
let s:ef_make = "make: *** [%f:%l:%m,"
let &errorformat = s:ef_cmocha . s:ef_make . &errorformat

" jumping to the first match happens after this
autocmd QuickfixCmdPost * GoHome | cclose | belowright cwindow
"
" quickfix


" expression register auto
"
" insert the results of an external command	:r !grep struct src/*.c
" insert the results of a vim expression	"=getbufvar("%", "&filetype")<C-M>p
" insert the results of a vim command		"=Exec("set!")<C-M>p
function Exec(command)
	redir =>output
	silent exec a:command
	redir END
	return output
endfunction
"
" expression register auto


" window conveniences
"
function GoToWinWithBufType(bt)

	if &buftype == a:bt
		return
	endif

	for l:wn in range(1, winnr("$"))
		if getbufvar(winbufnr(l:wn), "&buftype") == a:bt
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

command -bar GoHome call GoToWinWithBufType("")
command -bar GoHelp call GoToWinWithBufType("help")
"
" window conveniences


" airline
"
set noshowmode

let g:airline#extensions#searchcount#enabled = 0

let g:airline_section_y='w%{winnr()} b%{bufnr()}'
let g:airline_section_z='%2v %#__accent_bold#%3l%#__restore__#/%L'
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

" Start NERDTree when Vim is started without any arguments or stdin.
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree when Vim starts with single directory argument and focus it.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
			\ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | execute 'NERDTreeFocus' | endif

" listed buffer
" 'normal' buffer (buftype empty)
" readable file
function NERDTreeFindableBuf()
	return
				\ &buflisted &&
				\ strlen(&buftype) == 0 &&
				\ filereadable(bufname())
endfunction

" file under cwd: cd and find it, leave focus in tree, return 1
" other file: if tree at cwd, clear selection, return 0
" other buf: do nothing, return 0
" must have BufEnter events temporarily disabled
function NERDTreeReveal()
	if NERDTreeFindableBuf()
		let l:bname = bufname()
		if l:bname[0] != "/"
			NERDTreeCWD
			execute "NERDTreeFind " . l:bname
			return 1
		else
			NERDTreeFocus
			let l:cwdp = g:NERDTreePath.New(getcwd())
			if b:NERDTree.root.path.equals(l:cwdp)
				call b:NERDTree.render()
				call b:NERDTree.root.putCursorHere(0, 0)
			endif
			wincmd p
			return 0
		endif
	endif
	return 0
endfunction

function NERDTreeSmartFocus()
	let l:eiprev=&ei
	let &ei="BufEnter," . l:eiprev

	if g:NERDTree.IsOpen()
		NERDTreeFocus
	elseif !NERDTreeReveal()
		NERDTree
	endif

	let &ei=l:eiprev
endfunction

function NERDTreeSmartFind()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if NERDTreeFindableBuf()
		NERDTreeFind
	endif

	let &ei=l:eiprev
endfunction

function NERDTreeSync()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if g:NERDTree.IsOpen() && NERDTreeReveal()
		wincmd p
	endif

	let &ei=l:eiprev
endfunction
autocmd BufEnter * call NERDTreeSync()
"
" nerdtree


" nerdtree-git-plugin
"
let g:NERDTreeGitStatusMapPrevHunk = "<Leader>k"
let g:NERDTreeGitStatusMapNextHunk = "<Leader>j"

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
let g:gitgutter_close_preview_on_escape = 1
let g:gitgutter_preview_win_floating = 0
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
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-commentary'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Xuyuanp/nerdtree-git-plugin'
if !has('nvim')
	Plugin 'wincent/terminus'
endif
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

" lighter cursor line
highlight CursorLine ctermbg=19

