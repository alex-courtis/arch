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

if has('nvim')
	nmap	<silent>	<Leader>a	:call amc#nvt#smartFocus()<CR>
else
	nmap	<silent>	<Leader>;	:call amc#nt#smartFind()<CR>
	nmap	<silent>	<Leader>a	:call amc#nt#smartFocus()<CR>
endif
nmap	<silent>	<Leader>'	:call amc#win#closeInc()<CR>
nmap	<silent>	<Leader>"	:call amc#win#closeAll()<CR>

nmap	<silent>	<Leader>,	:call amc#win#openFocusGitPreview()<CR>
nmap	<silent>	<Leader><	:cclose<CR>
nmap	<silent>	<Leader>o	:call amc#win#goHomeOrNext()<CR>
nmap	<silent>	<Leader>O	:call amc#win#goHome()<CR>
nmap	<silent>	<Leader>q	:call amc#win#goHome() <Bar> belowright copen 15 <CR>

nmap	<silent>	<Leader>.	:call amc#qf#setGrepPattern()<Bar>set hlsearch<Bar>cnext<CR>
nmap	<silent>	<Leader>e	:call amc#win#goHome() <Bar> BufExplorer<CR>
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

" f
nmap	<silent>	<Leader>d	:call amc#mru#winRemove()<CR>
" b

nmap			<Leader>g	:ag "<C-r>=expand('<cword>')<CR>"
nmap			<Leader>G	:ag "<C-r>=expand('<cWORD>')<CR>"
vmap			<Leader>g	:<C-u>ag "<C-r>=amc#vselFirstLine()<CR>"
nmap	<silent>	<Leader>hu	<Plug>(GitGutterUndoHunk)
nmap	<silent>	<Leader>hs	<Plug>(GitGutterStageHunk)
xmap	<silent>	<Leader>hs	<Plug>(GitGutterStageHunk)
nmap	<silent>	<Leader>m	:make <CR>
nmap	<silent>	<Leader>M	:make clean <CR>

nmap	<silent>	<Leader>cu	<Plug>Commentary<Plug>Commentary
nmap	<silent>	<Leader>cc	<Plug>CommentaryLine
omap	<silent>	<Leader>c	<Plug>Commentary
nmap	<silent>	<Leader>c	<Plug>Commentary
xmap	<silent>	<Leader>c	<Plug>Commentary
nmap	<silent>	<Leader>t	<C-]>
nmap	<silent>	<Leader>T	:call settagstack(win_getid(), {'items' : []})<CR>
" vim-repeat doesn't seem to be able to handle a <BS> mapping
nmap	<silent>	<F12>w		viwp:let @+=@0<CR>:let @"=@0<CR>:call repeat#set("\<F12>w")<CR>
nmap	<silent>	<Leader>w	<F12>w

nmap			<Leader>r	:%s/<C-r>=expand('<cword>')<CR>/
nmap			<Leader>R	:%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>
vmap			<Leader>r	:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/
vmap			<Leader>R	:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/<C-r>=amc#vselFirstLine()<CR>
nmap	<silent>	<Leader>n	:tn<CR>
nmap	<silent>	<Leader>N	:tp<CR>
nmap	<silent>	<F12>v		:call amc#linewiseIndent("p", "\<F12>v")<CR>
nmap	<silent>	<Leader>v	<F12>v
nmap	<silent>	<F12>V		:call amc#linewiseIndent("P", "\<F12>V")<CR>
nmap	<silent>	<Leader>V	<F12>V

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

