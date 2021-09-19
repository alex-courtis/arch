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


nno 	; 	:
vno 	; 	:
nno 	q; 	q:
vno 	q; 	q:
nno 	@; 	@:
vno 	@; 	@:
nno 	<C-w>; 	<C-w>:
vno 	<C-w>; 	<C-w>:

nor	<silent>	<Esc>		<Esc>:nohlsearch<CR>
ino	<silent>	<Esc>		<Esc>:nohlsearch<CR>

nno	<silent>	<Leader>;	:call amc#nt#smartFind()<CR>
nno	<silent>	<Leader>a	:call amc#nt#smartFocus()<CR>
nno	<silent>	<Leader>A	:NERDTreeClose<CR>
nno	<silent>	<Leader>'	:call amc#closeOtherWin()<CR>

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

nno	<silent>	<Leader>t	<C-]>
nno	<silent>	<Leader>T	:call settagstack(win_getid(), {'items' : []})<CR>

nno	<silent>	<Leader>n	:tn<CR>
nno	<silent>	<Leader>N	:tp<CR>
nno			<Leader>r	:%s/

cno		<C-j>	<Down>
cno		<C-k>	<Up>


" appearance
let colors_name = "base16-bright"
let base16colorspace=256
autocmd ColorScheme * call amc#colours()

" commands
command -bar GoHome call amc#goToWinWithBufType("")
command -bar GoHelp call amc#goToWinWithBufType("help")

" commenting
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s

" grep
set grepprg=ag\ --nogroup\ --nocolor
cabbrev ag silent grep!

" quickfix
let s:ef_cmocha = "[   LINE   ] --- %f:%l:%m,"
let s:ef_make = "make: *** [%f:%l:%m,"
let &errorformat = s:ef_cmocha . s:ef_make . &errorformat
autocmd QuickfixCmdPost * GoHome | cclose | belowright cwindow

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

