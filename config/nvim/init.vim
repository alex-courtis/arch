filetype off
call vundle#begin("~/.local/share/nvim/vundle")
Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'Yohannfra/Vim-Goto-Header'
if !has('nvim')
	Plugin 'wincent/terminus'
endif
call vundle#end()
filetype plugin indent on


set clipboard=unnamedplus
set ignorecase
set smartcase
set nowrapscan
set autowriteall
set nohidden
set number
set cursorline
set mouse=a
set wildmode=longest:full,full
set undofile


nmap	;	:
vmap	;	:
nmap	q;	q:
vmap	q;	q:
nmap	@;	@:
vmap	@;	@:
nmap	<C-w>; 	<C-w>:
vmap	<C-w>; 	<C-w>:

nmap	<silent>	<Esc>		<Esc>:nohlsearch<CR>
imap	<silent>	<Esc>		<Esc>:nohlsearch<CR>

" begin left
let mapleader="\<Space>"

nmap	<silent>	<Leader>;	:call amc#nt#smartFind()<CR>
nmap	<silent>	<Leader>a	:call amc#nt#smartFocus()<CR>
nmap	<silent>	<Leader>'	:call amc#win#closeInc()<CR>
nmap	<silent>	<Leader>"	:call amc#win#closeAll()<CR>

nmap	<silent>	<Leader>,	:call amc#win#goHome() <Bar> aboveleft copen<CR>
nmap	<silent>	<Leader><	:cclose<CR>
nmap	<silent>	<Leader>o	:call amc#win#goHomeOrNext()<CR>
nmap	<silent>	<Leader>q	:call amc#win#openFocusGitPreview()<CR>

nmap	<silent>	<Leader>.	:call amc#qf#setGrepPattern()<Bar>set hlsearch<Bar>cnext<CR>
nmap	<silent>	<Leader>e	:call amc#buf#safeBufExplorer()<CR>
nmap	<silent>	<Leader>j	<Plug>(GitGutterNextHunk)
let	g:NERDTreeGitStatusMapNextHunk = "<Space>j"

nmap	<silent>	<Leader>p	:call amc#qf#setGrepPattern()<Bar>set hlsearch<Bar>cprev<CR>
nmap	<silent>	<Leader>u	:call amc#buf#safeHash()<CR>
nmap	<silent>	<Leader>k	<Plug>(GitGutterPrevHunk)
let	g:NERDTreeGitStatusMapPrevHunk = "<Space>k"

" y
nmap	<silent>	<Leader>i	:call amc#win#goHome() <Bar> TagbarOpen fj<CR>
" x

nmap	<silent>	<BS><BS>	:call amc#mru#back()<CR>
" end left

" begin right
let mapleader="\<BS>"

nmap			<Leader>f	:/<C-r>=expand("<cword>")<CR>
vmap			<Leader>f	:<C-u>/<C-r>=amc#vselFirstLine()<CR>
nmap	<silent>	<Leader>d	:call amc#mru#winRemove()<CR>
" b

nmap			<Leader>g	:ag <C-r>=expand("<cword>")<CR>
vmap			<Leader>g	:<C-u>ag "<C-r>=amc#vselFirstLine()<CR>"
nmap	<silent>	<Leader>hu	<Plug>(GitGutterUndoHunk)
nmap	<silent>	<Leader>hs	<Plug>(GitGutterStageHunk)
xmap	<silent>	<Leader>hs	<Plug>(GitGutterStageHunk)
nmap	<silent>	<Leader>m	:make<CR>
nmap	<silent>	<Leader>M	:make clean all<CR>

nmap	<silent>	<Leader>cu	<Plug>Commentary<Plug>Commentary
nmap	<silent>	<Leader>cc	<Plug>CommentaryLine
omap	<silent>	<Leader>c	<Plug>Commentary
nmap	<silent>	<Leader>c	<Plug>Commentary
xmap	<silent>	<Leader>c	<Plug>Commentary
nmap	<silent>	<Leader>t	<C-]>
nmap	<silent>	<Leader>T	:call settagstack(win_getid(), {'items' : []})<CR>
nmap	<silent>	<Leader>w	viwp:let @+=@0<CR>:let @"=@0<CR>:call repeat#set("\<Leader>w")<CR>

nmap			<Leader>r	:%s/<C-r>=expand("<cword>")<CR>/
nmap			<Leader>R	:%s/<C-r>=expand("<cword>")<CR>/<C-r>=expand("<cword>")<CR>
vmap			<Leader>r	:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/
vmap			<Leader>R	:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/<C-r>=amc#vselFirstLine()<CR>
nmap	<silent>	<Leader>n	:tn<CR>
nmap	<silent>	<Leader>N	:tp<CR>
nmap	<silent>	<Leader>v	o<Left><Right><Esc>p
nmap	<silent>	<Leader>V	O<Left><Right><Esc>p

" l
nmap	<silent>	<Leader>s	:GotoHeaderSwitch<CR>
nmap	<silent>	<Leader>z	gg=G``

" /
nmap	<silent>	<Leader>-	:GotoHeader<CR>
" \

nmap	<silent>	<Space><Space>	:call amc#mru#forward()<CR>

unlet mapleader
" end right

cmap		<C-j>	<Down>
cmap		<C-k>	<Up>

" hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
vmap <LeftRelease> "*ygv


" appearance
if match(system('underlyingterm'), 'st-256color\|alacritty') >= 0
	let base16colorspace=256
	autocmd ColorScheme * call amc#colours()
	colorscheme base16-bright
else
	set background=dark
endif

" grep
set grepprg=ag\ --vimgrep\ --debug
let &grepformat="ERR: %m,DEBUG: Query is %o,%-GDEBUG:%.%#,%f:%l:%c:%m,%f"
cabbrev ag silent grep!

" errorformat
let s:ef_cmocha = "%.%#[   LINE   ] --- %f:%l:%m,"
let s:ef_make = "make: *** [%f:%l:%m,"
let s:ef_cargo = "\\ %#--> %f:%l:%c,"
let &errorformat = s:ef_cmocha . s:ef_make . s:ef_cargo . &errorformat
" too many false positives
let &errorformat = substitute(&errorformat, ",%f:%l:%m,", ",", "")

" quickfix
autocmd QuickfixCmdPost * call amc#qf#cmdPost()
autocmd FileType qf call amc#qf#setGrepPattern()

" omnicompletion
set completeopt=menuone,longest
ino	<expr>	<C-Space>	amc#omni#begin()
ino	<expr>	<C-n>		amc#omni#next()
ino	<expr>	<C-x><C-o>	amc#omni#begin()
ino	<expr>	<CR>		amc#omni#maybeSelectFirstAndAccept()
ino	<expr>	<Tab>		pumvisible() ? "\<C-n>" : "\<Tab>"
ino	<expr>	<S-Tab>		pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd CompleteDone * call amc#omni#end()

" insert the results of a vim command e.g. "=Exe("set all")<C-M>p
function! Exe(command)
	redir =>output
	silent exec a:command
	redir END
	return output
endfunction

" from vim
autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ |   exe "normal! g`\""
			\ | endif

" autosave
autocmd BufLeave * silent! :w
autocmd FocusLost * silent! :w

" terminal title
set title
autocmd BufEnter	* call amc#updateTitleString()
autocmd BufWritePost	* call amc#updateTitleString()
autocmd FocusGained	* call amc#updateTitleString()
autocmd VimEnter	* call amc#updateTitleString()

" find
cabbrev f find
autocmd VimEnter	* call amc#setPathCwd()

" tags search down only
set tags=**/tags

" mru
autocmd BufLeave * call amc#mru#bufLeave()
autocmd WinNew * call amc#mru#winNew()

" stay away from special windows
autocmd BufLeave * call amc#win#updateSpecial()
autocmd BufEnter * call amc#win#moveFromSpecial()

" airline
set noshowmode
let g:airline#extensions#searchcount#enabled = 0
let g:airline_section_x=''
let g:airline_section_y='%{airline#util#wrap(airline#parts#filetype(),0)}'
let g:airline_section_z='%2v %#__accent_bold#%3l%#__restore__#/%L'
let g:airline#extensions#whitespace#checks=['trailing', 'conflicts']

" bufexplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowNoName=1

" editorconfig
let EditorConfig_max_line_indicator='line'

" Goto-Header
let g:goto_header_associate_cpp_h = 1
let g:goto_header_includes_dirs = [".", "/usr/include"]

" nerdtree
set wildignore+=*.o,*.class
let NERDTreeRespectWildIgnore = 1
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeMapQuit = '<Esc>'
let g:amc#nt#stdin = 0
autocmd StdinReadPre * call amc#nt#stdinReadPre()
autocmd VimEnter * call amc#nt#vimEnter()
autocmd BufEnter * call amc#nt#sync()

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

" tagbar
let g:tagbar_compact=1
let tagbar_map_close='<Esc>'
let tagbar_map_showproto=''
let g:tagbar_silent = 1

" vim-commentary
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
" stop the plugin from creating the default mappings
nmap	gc	<NOP>

" vim-gitgutter
set updatetime=100
let g:gitgutter_close_preview_on_escape = 1
let g:gitgutter_preview_win_floating = 0
let g:gitgutter_preview_win_location = 'belowright'


" local overrides
call amc#sourceIfExists("local.vim")
call amc#sourceIfExists("amc/local.vim")

let g:amcLog = 0
let g:amcLogMru = 0

