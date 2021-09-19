" vundle
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
" vundle


" unnamedplus: yank etc. uses the + register, synced with X or wayland clipboard
set clipboard=unnamedplus

set ignorecase
set smartcase

set nowrapscan

set autowriteall

set number relativenumber

set cursorline

set mouse=a

" longest:full is necessary as :help does not obey longest
set wildmode=longest:full,full

set undofile

set scrolloff=3


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


nor	<silent>	<Esc>		<Esc>:nohlsearch<CR>
ino	<silent>	<Esc>		<Esc>:nohlsearch<CR>


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


" appearance
"
let colors_name = "base16-bright"

if (&t_Co >= 255)
	" base16 schemes use the bonus colours 17-21
	" see https://github.com/chriskempson/base16-shell
	let base16colorspace=256
endif
autocmd ColorScheme * call amc#colours()

"
" appearance


" commenting
"
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
"
" commenting


" grep
"
set grepprg=ag\ --nogroup\ --nocolor

cabbrev ag silent grep!
"
" grep


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
command -bar GoHome call amc#goToWinWithBufType("")
command -bar GoHelp call amc#goToWinWithBufType("help")
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


runtime! nerdtree.vim
runtime! omnicomplete.vim

