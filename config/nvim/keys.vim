nm	;	:
vm	;	:
nm	q;	q:
vm	q;	q:
nm	@;	@:
vm	@;	@:
nm	<C-w>; 	<C-w>:
vm	<C-w>; 	<C-w>:

nn	cw	ciw
nn	cfw	cw
nn	dw	diw
nn	dfw	dw
nn	yw	yiw
nn	yfw	yw

nm	<silent>	<Esc>		<Esc>:nohlsearch<CR>
im	<silent>	<Esc>		<Esc>:nohlsearch<CR>

" begin left
let mapleader="\<Space>"

if has('nvim')
	nm	<silent>	<Leader>a	:NvimTreeFindFile<CR>:NvimTreeFocus<CR>
	nm	<silent>	<Leader>A	:NvimTreeRefresh<CR>
else
	nm	<silent>	<Leader>;	:call amc#nt#smartFind()<CR>
	nm	<silent>	<Leader>a	:call amc#nt#smartFocus()<CR>
endif
nm	<silent>	<Leader>'	:call amc#win#closeInc()<CR>
nm	<silent>	<Leader>"	:call amc#win#closeAll()<CR>

nm	<silent>	<Leader>,	:call amc#win#openFocusGitPreview()<CR>
nm	<silent>	<Leader><	:cclose<CR>
nm	<silent>	<Leader>o	:call amc#win#goHomeOrNext()<CR>
nm	<silent>	<Leader>O	:call amc#win#goHome()<CR>
nm	<silent>	<Leader>q	:call amc#win#goHome() <Bar> belowright copen 15 <CR>

nm	<silent>	<Leader>.	:if amc#qf#setGrepPattern() <Bar> set hlsearch <Bar> endif <Bar> cnext<CR>
nm	<silent>	<Leader>e	:call amc#win#openBufExplorer()<CR>
nm	<silent>	<Leader>j	<Plug>(GitGutterNextHunk)
let	g:NERDTreeGitStatusMapNextHunk = "<Space>j"

nm	<silent>	<Leader>p	:if amc#qf#setGrepPattern() <Bar> set hlsearch <Bar> endif <Bar> cprev<CR>
nm	<silent>	<Leader>u	:call amc#buf#safeHash()<CR>
nm	<silent>	<Leader>k	<Plug>(GitGutterPrevHunk)
let	g:NERDTreeGitStatusMapPrevHunk = "<Space>k"

" y
nm	<silent>	<Leader>i	:call amc#win#goHome() <Bar> TagbarOpen fj<CR>
" x

nm	<silent>	<BS><BS>	:call amc#mru#back()<CR>
" end left

" begin right
let mapleader="\<BS>"

" f
nm	<silent>	<Leader>d	:call amc#mru#winRemove()<CR>
" b

nm			<Leader>g	:ag "<C-r>=expand('<cword>')<CR>"
nm			<Leader>G	:ag "<C-r>=expand('<cWORD>')<CR>"
vm			<Leader>g	:<C-u>ag "<C-r>=amc#vselFirstLine()<CR>"
nm	<silent>	<Leader>hu	<Plug>(GitGutterUndoHunk)
nm	<silent>	<Leader>hs	<Plug>(GitGutterStageHunk)
xm	<silent>	<Leader>hs	<Plug>(GitGutterStageHunk)
nm	<silent>	<Leader>m	:make <CR>
nm	<silent>	<Leader>M	:make clean <CR>

nm	<silent>	<Leader>cu	<Plug>Commentary<Plug>Commentary
nm	<silent>	<Leader>cc	<Plug>CommentaryLine
om	<silent>	<Leader>c	<Plug>Commentary
nm	<silent>	<Leader>c	<Plug>Commentary
xm	<silent>	<Leader>c	<Plug>Commentary
nm	<silent>	<Leader>t	<C-]>
nm	<silent>	<Leader>T	:call settagstack(win_getid(), {'items' : []})<CR>
" vim-repeat doesn't seem to be able to handle a <BS> mapping
nm	<silent>	<F12>w		viwp:let @+=@0<CR>:let @"=@0<CR>:call repeat#set("\<F12>w")<CR>
nm	<silent>	<Leader>w	<F12>w

nm			<Leader>r	:%s/<C-r>=expand('<cword>')<CR>/
nm			<Leader>R	:%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>
vm			<Leader>r	:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/
vm			<Leader>R	:<C-u>%s/<C-r>=amc#vselFirstLine()<CR>/<C-r>=amc#vselFirstLine()<CR>
nm	<silent>	<Leader>n	:tn<CR>
nm	<silent>	<Leader>N	:tp<CR>
nm	<silent>	<F12>v		:call amc#linewiseIndent("p", "\<F12>v")<CR>
nm	<silent>	<Leader>v	<F12>v
nm	<silent>	<F12>V		:call amc#linewiseIndent("P", "\<F12>V")<CR>
nm	<silent>	<Leader>V	<F12>V

" l
nm	<silent>	<Leader>s	:GotoHeaderSwitch<CR>
nm	<silent>	<Leader>z	gg=G``

" /
nm	<silent>	<Leader>-	:GotoHeader<CR>
" \

nm	<silent>	<Space><Space>	:call amc#mru#forward()<CR>

unlet mapleader
" end right

cm		<C-j>	<Down>
cm		<C-k>	<Up>

" hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
vm <LeftRelease> "*ygv

