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
set autowrite

set listchars=trail:·,tab:>\ ,eol:¬

set formatoptions+=j

set number relativenumber

" longest:full is necessary as :help does not obey longest
set wildmode=longest:full,full

" unadjusted ANSI base16 colours only
if &t_Co > 16 && !&diff
	set t_Co=16
endif
set background=

if !empty($TERMINAL_THEME)
	let &titlestring='%f %m%r {' . $TERMINAL_THEME . '}'
else
	let &titlestring='%f %m%r'
endif

" alacritty, st, xterm and tmux all talk sgr
" terminus automatically sets it when under tmux
" vim hardcodes st to 'xterm' and xterm to 'sgr'
" sgr is desirable as one of its side effects is the ability to handle modified F1-F4
if $TERM =~ 'alacritty' || $TERM =~ 'st-'
	set ttymouse=sgr
endif


" vim needs to be told explicitly listen for modified function keys
"
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


" mappings - vim specific
"
nno 	; 	:
vno 	; 	:
nno 	q; 	q:
vno 	q; 	q:
nno 	@; 	@:
vno 	@; 	@:
nno 	<C-w>; 	<C-w>:
vno 	<C-w>; 	<C-w>:

nno	<silent>	<Leader>b	:BufExplorer<CR>
nno	<silent>	<Leader>ta	:TagbarToggle<CR>
nno	<silent>	<Leader>tr	:NERDTreeToggle<CR>
nno	<silent>	<Leader>h	:nohl<CR>

" mappings - common
"
nno		<F5>	:b #<CR>

cno		<C-j>	<Down>
cno		<C-k>	<Up>

ino	<expr>	<C-@>	BeginOmniComplete()

nmap		<F7>	<Plug>(GitGutterNextHunk)
nmap		<S-F7>	<Plug>(GitGutterPrevHunk)

nmap			<Plug>NERDCommenterToggle <Down>
xmap			<Plug>NERDCommenterToggle


" completion
"
set completeopt=menuone,preview,longest

" turn off ignore case, as mixed case matches result in longest length 0
function! BeginOmniComplete()
	set noignorecase
	return "\<C-x>\<C-o>"
endfunction

" turn on ignore case and close the preview
autocmd CompleteDone * set ignorecase | pclose


" airline
"
set noshowmode

let airline_powerline_fonts=1

let airline_section_x='%{airline#extensions#tagbar#currenttag()}'
let airline_section_y='%{airline#parts#filetype()}'
let airline_section_z='%3v %#__accent_bold#%3l%#__restore__# / %L %3P'


" bufexplorer
"
let g:bufExplorerDefaultHelp=0
let g:bufExplorerDisableDefaultKeyMapping=1


" editorconfig
"
let EditorConfig_max_line_indicator='exceeding'


" nerdcommenter
"
let NERDCreateDefaultMappings=0
let NERDToggleCheckAllLines=1
let NERDDefaultAlign='both'
let NERDSpaceDelims=1
let NERDRemoveExtraSpaces=1


" nerdtree
"
let NERDTreeMinimalUI=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" tagbar
"
let g:tagbar_compact=1


" vim-gitgutter
"
set updatetime=250


" plugins as late as possible
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'guns/xterm-color-table.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'preservim/nerdcommenter'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'wincent/terminus'
Plugin 'Xuyuanp/nerdtree-git-plugin'
call vundle#end()


" Does not change terminal colours, just the syntax to ANSI 16 colour mappings.
" This also selects the base16 vim-airline-theme
colorscheme base16-default-dark

