filetype off
let &rtp .= ",~/.local/share/nvim/vundle/Vundle.vim"
call vundle#begin("~/.local/share/nvim/vundle")
Plugin 'VundleVim/Vundle.vim'

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
set number relativenumber
set cursorline
set mouse=a
set wildmode=longest:full,full
set undofile
set scrolloff=3


nmap	;	:
vmap	;	:
nmap	q;	q:
vmap	q;	q:
nmap	@;	@:
vmap	@;	@:
nmap	<C-w>; 	<C-w>:
vmap	<C-w>; 	<C-w>:

map	Y	y$

nmap	<silent>	<Esc>		<Esc>:nohlsearch<CR>
imap	<silent>	<Esc>		<Esc>:nohlsearch<CR>

nmap	<silent>	<Leader>;	:call amc#nt#smartFind()<CR>
nmap	<silent>	<Leader>a	:call amc#nt#smartFocus()<CR>
nmap	<silent>	<Leader>'	:call amc#win#closeAll()<CR>

nmap	<silent>	<Leader>,	:call amc#win#goHome() <Bar> aboveleft copen<CR>
nmap	<silent>	<Leader><	:cclose<CR>
nmap	<silent>	<Leader>o	:call amc#win#goHomeOrNext()<CR>
nmap	<silent>	<Leader>q	:call amc#win#openFocusGitPreview()<CR>

nmap	<silent>	<Leader>.	:cnext <Bar> if g:amc#grepping <Bar> set hlsearch <Bar> endif<CR>
nmap	<silent>	<Leader>e	:call amc#safeBufExplorer()<CR>
nmap	<silent>	<Leader>j	<Plug>(GitGutterNextHunk)

nmap	<silent>	<Leader>p	:cprev <Bar> if g:amc#grepping <Bar> set hlsearch <Bar> endif<CR>
nmap	<silent>	<Leader>u	:call amc#buf#safeHash()<CR>
nmap	<silent>	<Leader>k	<Plug>(GitGutterPrevHunk)

" y
nmap	<silent>	<Leader>i	:call amc#win#goHome() <Bar> TagbarOpen fj<CR>
" x

nmap			<F12>f		:/<C-r>=expand("<cword>")<CR>
vmap			<F12>f		:<C-u>/<C-r>=amc#vselFirstLine()<CR>
nmap	<silent>	<F12>d		:call amc#buf#del()<CR>
" b

nmap			<F12>g		:ag <C-r>=expand("<cword>")<CR>
vmap			<F12>g		:<C-u>ag "<C-r>=amc#vselFirstLine()<CR>"
nmap	<silent>	<F12>hu		<Plug>(GitGutterUndoHunk)
nmap	<silent>	<F12>hs		<Plug>(GitGutterStageHunk)
xmap	<silent>	<F12>hs		<Plug>(GitGutterStageHunk)
nmap	<silent>	<F12>m		:make<CR>
nmap	<silent>	<F12>M		:make clean all<CR>

nmap	<silent>	<F12>cu		<Plug>Commentary<Plug>Commentary
nmap	<silent>	<F12>cc		<Plug>CommentaryLine
omap	<silent>	<F12>c		<Plug>Commentary
nmap	<silent>	<F12>c		<Plug>Commentary
xmap	<silent>	<F12>c		<Plug>Commentary
nmap	<silent>	<F12>t		<C-]>
nmap	<silent>	<F12>T		:call settagstack(win_getid(), {'items' : []})<CR>
nmap	<silent>	<F12>w		viwp:let @+=@0<CR>:let @"=@0<CR>:call repeat#set("\<F12>w")<CR>

nmap			<F12>r		:%s/<C-r>=expand("<cword>")<CR>/
nmap			<F12>R		:%s/<C-r>=expand("<cword>")<CR>/<C-r>=expand("<cword>")<CR>
vmap			<F12>r		:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/
vmap			<F12>R		:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/<C-r>=amc#vselFirstLine()<CR>
nmap	<silent>	<F12>n		:tn<CR>
nmap	<silent>	<F12>N		:tp<CR>
nmap	<silent>	<F12>v		o<Left><Right><Esc>p
nmap	<silent>	<F12>V		O<Left><Right><Esc>p

" l
nmap	<silent>	<F12>s		:GotoHeaderSwitch<CR>
nmap	<silent>	<F12>z		gg=G``

" /
nmap	<silent>	<F12>-		:GotoHeader<CR>
" \

cmap		<C-j>	<Down>
cmap		<C-k>	<Up>


" appearance
let colors_name = "base16-bright"
let base16colorspace=256
autocmd ColorScheme * call amc#colours()

" grep
set grepprg=ag\ --vimgrep
let &grepformat="%f:%l:%c:%m, %f"
cabbrev ag silent grep!

" quickfix
let s:ef_cmocha = "[   LINE   ] --- %f:%l:%m,"
let s:ef_make = "make: *** [%f:%l:%m,"
let &errorformat = s:ef_cmocha . s:ef_make . &errorformat
let g:amc#grepping = 0
autocmd QuickfixCmdPost * call amc#qfPost()
autocmd FileType qf nmap <buffer> <Esc> :q<CR>

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
autocmd FocusLost * silent! :w

" help
autocmd FileType help nmap <buffer> <Esc> :q<CR>

" terminal title
set title
autocmd BufWritePost	* let &titlestring = system('. termtitle')
autocmd FocusGained	* let &titlestring = system('. termtitle')
autocmd VimEnter	* let &titlestring = system('. termtitle')

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
let tagbar_map_close = '<Esc>'

" vim-commentary
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
" stop the plugin from creating the default mappings
nmap	gc	<NOP>

" vim-gitgutter
set updatetime=250
let g:gitgutter_close_preview_on_escape = 1
let g:gitgutter_preview_win_floating = 0
let g:gitgutter_preview_win_location = 'belowright'

