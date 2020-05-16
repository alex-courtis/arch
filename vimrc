runtime! defaults.vim

" unnamedplus: yank etc. uses the + register, synced with XA_CLIPBOARD
" autoselect: visual selections go to * register, synced with XA_PRIMARY
if has('nvim')
	set clipboard+=unnamedplus
else
	set clipboard=unnamedplus,autoselect,exclude:cons\|linux
endif

set hlsearch
set ignorecase
set smartcase
set nowrapscan

set listchars=trail:·,tab:>\ ,eol:¬

set formatoptions+=j

set number relativenumber

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

" works for xterm, st, tmux, alacritty with TERM=st-256color
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

" bindings
"
"
cmap	<C-j>	<Down>
cmap	<C-k>	<Up>

map 	; 	:
map 	q; 	q:
map 	@; 	@:
map 	<C-w>; 	<C-w>:

nmap 	<F5> 	:NERDTreeToggle<CR>
nmap 	<F8> 	:TagbarToggle<CR>


" Automatically set to sgr by terminus when running under tmux.
" The side affect is whether vim can handle shifted/modified F1-F4.
if $TERM =~ 'alacritty' || $TERM =~ 'st-'
	set ttymouse=sgr
endif
" alacritty NULL
" alacritty+tmux 'xterm'
" alacritty+terminus NULL
" alacritty+tmux+terminus 'sgr'
"
" st 'xterm'
" st+terminus 'xterm'  --  not the expected result
" st+tmux 'xterm'
" st+tmux+terminus 'sgr'
"
" xterm 'sgr'
" xterm+terminus 'sgr'
" xterm+tmux 'xterm'
" xterm+tmux+terminus 'sgr'


nmap <C-F1> <Plug>(GitGutterPrevHunk)
nmap <S-F1> <Plug>(GitGutterPrevHunk)
nmap <A-F1> <Plug>(GitGutterPrevHunk)
nmap <F1> <Plug>(GitGutterNextHunk)

nmap <C-F4> <Plug>(GitGutterPrevHunk)
nmap <S-F4> <Plug>(GitGutterPrevHunk)
nmap <A-F4> <Plug>(GitGutterPrevHunk)
nmap <F4> <Plug>(GitGutterNextHunk)

nmap <C-F7> <Plug>(GitGutterPrevHunk)
nmap <S-F7> <Plug>(GitGutterPrevHunk)
nmap <A-F7> <Plug>(GitGutterPrevHunk)
nmap <F7> <Plug>(GitGutterNextHunk)

" plugins now, so that changes such as t_Co are taken into account
"
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'guns/xterm-color-table.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'wincent/terminus'
call vundle#end()


" Does not change terminal colours, just the syntax to ANSI 16 colour mappings.
" This also selects the base16 vim-airline-theme
"
colorscheme base16-default-dark


" vim-gitgutter
"
set updatetime=250


" editorconfig
"
let g:EditorConfig_max_line_indicator='fill'


" airline
"
set noshowmode

let g:airline_powerline_fonts = 1

let g:airline_section_x = '%{airline#extensions#tagbar#currenttag()}'
let g:airline_section_y = '%{airline#parts#filetype()}'
let g:airline_section_z = '%3v %#__accent_bold#%3l%#__restore__# / %L %3P'

