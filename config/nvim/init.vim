filetype off
let &rtp .= "," . $XDG_DATA_HOME . "/nvim/vundle/Vundle.vim"
call vundle#begin($XDG_DATA_HOME . "/nvim/vundle")
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
set number relativenumber
set cursorline
set mouse=a
set wildmode=longest:full,full
set undofile
set scrolloff=3


nmap 	; 	:
vmap 	; 	:
nmap 	q; 	q:
vmap 	q; 	q:
nmap 	@; 	@:
vmap 	@; 	@:
nmap 	<C-w>; 	<C-w>:
vmap 	<C-w>; 	<C-w>:

nmap	<silent>	<Esc>		<Esc>:nohlsearch<CR>
imap	<silent>	<Esc>		<Esc>:nohlsearch<CR>

nmap	<silent>	<Leader>;	:call amc#nt#smartFind()<CR>
nmap	<silent>	<Leader>a	:call amc#nt#smartFocus()<CR>
nmap	<silent>	<Leader>A	:NERDTreeClose<CR>
nmap	<silent>	<Leader>'	:call amc#closeAll()<CR>

nmap	<silent>	<Leader>,	:call amc#goHelp()<CR>
nmap	<silent>	<Leader><	:helpclose<CR>
nmap	<silent>	<Leader>o	:call amc#goHomeOrNext()<CR>
nmap	<silent>	<Leader>q	:call amc#goHome() <Bar> belowright copen<CR>
nmap	<silent>	<Leader>Q	:cclose<CR>

nmap	<silent>	<Leader>.	:cnext<CR>
nmap	<silent>	<Leader>e	:call amc#goHome() <Bar> ToggleBufExplorer<CR>
nmap	<silent>	<Leader>j	<Plug>(GitGutterNextHunk)

nmap	<silent>	<Leader>p	:cprev<CR>
nmap	<silent>	<Leader>u	:b#<CR>
nmap	<silent>	<Leader>k	<Plug>(GitGutterPrevHunk)

nmap	<silent>	<Leader>i	:call amc#goHome() <Bar> TagbarOpen fj<CR>
nmap	<silent>	<Leader>I	:TagbarClose<CR>

nmap	<silent>	<F12>f		gg=G``
nmap	<silent>	<F12>d		:call amc#delBuf()<CR>

nmap	<silent>	<F12>g		:ag <cword><CR>
nmap	<silent>	<F12>hc		:call gitgutter#hunk#close_hunk_preview_window()<CR>
nmap	<silent>	<F12>hp		<Plug>(GitGutterPreviewHunk)
nmap	<silent>	<F12>hu		<Plug>(GitGutterUndoHunk)
nmap	<silent>	<F12>hs		<Plug>(GitGutterStageHunk)
xmap	<silent>	<F12>hs		<Plug>(GitGutterStageHunk)
nmap	<silent>	<F12>m		:make<CR>
nmap	<silent>	<F12>M		:make clean<CR>

nmap	<silent>	<F12>cu		<Plug>Commentary<Plug>Commentary
nmap	<silent>	<F12>cc		<Plug>CommentaryLine
omap	<silent>	<F12>c		<Plug>Commentary
nmap	<silent>	<F12>c		<Plug>Commentary
xmap	<silent>	<F12>c		<Plug>Commentary
nmap	<silent>	<F12>t		<C-]>
nmap	<silent>	<F12>T		:call settagstack(win_getid(), {'items' : []})<CR>

nmap			<F12>r		:%s/
nmap	<silent>	<F12>n		:tn<CR>
nmap	<silent>	<F12>N		:tp<CR>

nmap	<silent>	<F12>s		:GotoHeaderSwitch<CR>

nmap	<silent>	<F12>-		:GotoHeader<CR>

cmap		<C-j>	<Down>
cmap		<C-k>	<Up>


" appearance
let colors_name = "base16-bright"
let base16colorspace=256
autocmd ColorScheme * call amc#colours()

" vim-commentary
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
" stop the plugin from creating the default mappings
nmap	gc	<NOP>

" grep
set grepprg=ag\ --nogroup\ --nocolor
cabbrev ag silent grep!

" quickfix
let s:ef_cmocha = "[   LINE   ] --- %f:%l:%m,"
let s:ef_make = "make: *** [%f:%l:%m,"
let &errorformat = s:ef_cmocha . s:ef_make . &errorformat
autocmd QuickfixCmdPost * call amc#goHome() | cclose | belowright cwindow

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

" airline
set noshowmode
let g:airline#extensions#searchcount#enabled = 0
let g:airline_section_y='w%{winnr()} b%{bufnr()}'
let g:airline_section_z='%2v %#__accent_bold#%3l%#__restore__#/%L'
let g:airline#extensions#whitespace#checks=['trailing', 'conflicts']

" bufexplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerDisableDefaultKeyMapping=1

" editorconfig
let EditorConfig_max_line_indicator='line'

" Goto-Header
let g:goto_header_associate_cpp_h = 1
let g:goto_header_includes_dirs = [".", "/usr/include"]

" nerdtree-git-plugin
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

" tagbar
let g:tagbar_compact=1

" vim-gitgutter
set updatetime=250
let g:gitgutter_close_preview_on_escape = 1
let g:gitgutter_preview_win_floating = 0

