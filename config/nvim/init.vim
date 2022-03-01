filetype off
call vundle#begin("~/.local/share/nvim/vundle")
Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Yohannfra/Vim-Goto-Header'
if has('nvim')
	Plugin 'kyazdani42/nvim-tree.lua'
	Plugin 'kyazdani42/nvim-web-devicons'
else
	Plugin 'preservim/nerdtree'
	Plugin 'Xuyuanp/nerdtree-git-plugin'
	Plugin 'wincent/terminus'
endif
call vundle#end()
filetype plugin indent on

set autowriteall
set clipboard=unnamedplus
set cursorline
set ignorecase
set mouse=a
set nowrapscan
set number
set smartcase
set switchbuf=useopen,uselast
set termguicolors
set title
set undofile

runtime keys.vim

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
command -nargs=+ -complete=file_in_path AG silent grep! <args> <Bar> set hlsearch
cabbrev ag AG

" errorformat
let s:ef_cmocha = "%.%#[   LINE   ] --- %f:%l:%m,"
let s:ef_make = "make: *** [%f:%l:%m,"
let s:ef_cargo = "\\ %#--> %f:%l:%c,"
let &errorformat = s:ef_cmocha . s:ef_make . s:ef_cargo . &errorformat

" put the results of a silent command in a new scratch
command -nargs=+ S enew | setlocal buftype=nofile | setlocal bufhidden=hide | setlocal noswapfile | redir @z | silent <args> | redir end | put z

" default only in vim: return to last edit point
autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ |   exe "normal! g`\""
			\ | endif

" find
cabbrev f find
" unused command kept here for reference
" command -nargs=1 -complete=file_in_path F call amc#win#goHome() | find <args>
" cabbrev f F

" tags search down only
set tags=**/tags

" mru
cabbrev ml call amc#mru#prn("mru w" . winnr(), 1)

" airline
set noshowmode
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#searchcount#enabled = 0
let g:airline_section_x=''
let g:airline_section_y = airline#section#create_right(['filetype'])
call airline#parts#define('colnr', { 'raw': '%v ', 'accent': 'none'})
call airline#parts#define('linenr', { 'raw': '%l', 'accent': 'bold'})
call airline#parts#define('maxlinenr', { 'raw': '/%L', 'accent': 'none'})
let g:airline_section_z = airline#section#create(['colnr', 'linenr', 'maxlinenr'])
let g:airline#extensions#whitespace#checks=['trailing', 'conflicts']
call airline#add_statusline_func('amc#airlineSpecialDetector')

" bufexplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowNoName=1

" editorconfig
let EditorConfig_max_line_indicator='line'

" Goto-Header
let g:goto_header_associate_cpp_h = 1
let g:goto_header_includes_dirs = [".", "/usr/include"]

if has('nvim')
	" nvimtree
	lua require 'nvt'
else
	" nerdtree
	set wildignore+=*.o,*.class
	let NERDTreeRespectWildIgnore = 1
	let NERDTreeMinimalUI = 1
	let g:NERDTreeDirArrowExpandable = '+'
	let g:NERDTreeDirArrowCollapsible = '-'
	let g:NERDTreeMapQuit = '<Esc>'

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
endif

" tagbar
let g:tagbar_compact=1
let tagbar_map_showproto=''
let g:tagbar_silent = 1
let g:tagbar_sort = 0

" vim-commentary
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
" stop the plugin from creating the default mappings
nmap	gc	<NOP>

" vim-gitgutter
set updatetime=100
let g:gitgutter_close_preview_on_escape = 1
let g:gitgutter_preview_win_floating = 0
let g:gitgutter_preview_win_location = 'aboveleft'


" event order matters
autocmd BufEnter * call amc#win#markSpecial()
autocmd BufEnter * call amc#win#ejectFromSpecial()
autocmd BufEnter * call amc#buf#wipeAltNoNameNew()
autocmd BufEnter * call amc#mru#update()
autocmd BufEnter * call amc#updateTitleString()
if !has('nvim')
	autocmd BufEnter * call amc#nt#sync()
end
autocmd BufLeave * ++nested call amc#buf#autoWrite()
autocmd BufWritePost * call amc#updateTitleString()
autocmd DirChanged global call amc#updatePath()
autocmd FileType * call amc#win#markSpecial()
autocmd FileType qf call amc#qf#setGrepPattern()
autocmd FocusGained * call amc#updateTitleString()
autocmd FocusLost * ++nested call amc#buf#autoWrite()
autocmd QuickfixCmdPost * ++nested call amc#qf#cmdPost()
autocmd VimEnter * call amc#startupCwd()
autocmd VimEnter * call amc#updateTitleString()
if !has('nvim')
	autocmd VimEnter * call amc#nt#startup()
endif
autocmd WinNew * call amc#mru#winNew()

" log
" let g:amcLog = 1
" let g:amcLogMru = 1
" call amc#log#startEventLogging()

