filetype off
call vundle#begin("~/.local/share/nvim/vundle")

Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'qpkorr/vim-bufkill'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'Yohannfra/Vim-Goto-Header'

" plugin and coc-settings.json retained for coc replications
" Plugin 'neoclide/coc.nvim'

if has('nvim')
	Plugin 'hrsh7th/cmp-buffer'
	Plugin 'hrsh7th/cmp-cmdline'
	Plugin 'hrsh7th/cmp-nvim-lsp'
	Plugin 'hrsh7th/cmp-path'
	Plugin 'hrsh7th/cmp-vsnip'
	Plugin 'hrsh7th/nvim-cmp'
	Plugin 'hrsh7th/vim-vsnip'
	Plugin 'kyazdani42/nvim-tree.lua'
	Plugin 'kyazdani42/nvim-web-devicons'
	Plugin 'lewis6991/gitsigns.nvim'
	Plugin 'neovim/nvim-lspconfig'
else
	Plugin 'preservim/nerdtree'
	Plugin 'Xuyuanp/nerdtree-git-plugin'
	Plugin 'wincent/terminus'
endif

call vundle#end()
filetype plugin indent on

set autowriteall
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set cursorline
set ignorecase
set lcs+=space:·
set mouse=a
set nowrapscan
set number
set pumheight=15
set pumwidth=30
set shiftwidth=4
set smartcase
set switchbuf=useopen,uselast
set tabstop=4
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

" put the results of a silent command in " and +
command -nargs=+ C redir @" | silent exec <q-args> | redir end | let @+ = @"

" default only in vim: return to last edit point
autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ |   exe "normal! g`\""
			\ | endif

" tags search down only
set tags=**/tags

" mru
cabbrev ml call amc#mru#prn("mru w" . winnr(), 1)

" start neovim only plugins
if has('nvim')
	lua require 'amc/cmp'.setup()
	lua require 'amc/gitsigns'.setup()
	lua require 'amc/lsp'.setup()
	lua require 'amc/nvim-tree'.setup()
endif

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
call airline#add_statusline_func('amc#airlineStatusLine')
call airline#add_inactive_statusline_func('amc#airlineStatusLine')

" bufexplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowNoName=1

" buf-kill
let g:BufKillCreateMappings = 1

" editorconfig
let EditorConfig_max_line_indicator='line'

" Goto-Header
let g:goto_header_associate_cpp_h = 1
let g:goto_header_includes_dirs = [".", "/usr/include"]

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


" event order matters
autocmd BufEnter * call amc#buf#wipeAltNoNameNew()
autocmd BufEnter * call amc#mru#update()
autocmd BufEnter * call amc#updateTitleString()
autocmd BufLeave * ++nested call amc#buf#autoWrite()
autocmd BufWritePost * call amc#updateTitleString()
autocmd DirChanged global call amc#updatePath()
autocmd FileType qf call amc#qf#setGrepPattern()
autocmd FocusGained * call amc#updateTitleString()
autocmd FocusLost * ++nested call amc#buf#autoWrite()
autocmd QuickfixCmdPost * ++nested call amc#qf#cmdPost()
autocmd VimEnter * call amc#startupCwd()
autocmd VimEnter * call amc#updateTitleString()
autocmd WinClosed * call amc#win#wipeOnClosed()
autocmd WinNew * call amc#mru#winNew()

" log
" let g:amcLog = 1
" let g:amcLogMru = 1
" call amc#log#startEventLogging()

