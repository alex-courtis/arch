nm	;	:
vm	;	:
nm	q;	q:
vm	q;	q:
nm	@;	@:
vm	@;	@:
nm	<C-w>; 	<C-w>:
vm	<C-w>; 	<C-w>:

nn	yw	yiw
nn	yfw	yw

nm	<silent>	<Esc>		<Esc>:nohlsearch<CR>
im	<silent>	<Esc>		<Esc>:nohlsearch<CR>

for s:leader in [ "\<Space>", "\<BS>", ]
let mapleader=s:leader

" begin left
" $
" @
" \ used by right

nm	<silent>	<Leader>;	:call amc#win#goHome() <Bar> belowright copen 15 <CR>
nm	<silent>	<Leader>:	:cclose<CR>
nm	<silent>	<Leader>a	:NvimTreeFindFile<CR>:NvimTreeFocus<CR>
nm	<silent>	<Leader>A	:NvimTreeCollapse<CR><Leader>a
nm	<silent>	<Leader>'	:call amc#win#closeInc()<CR>
nm	<silent>	<Leader>"	:call amc#win#closeAll()<CR>

nm	<silent>	<Leader>,	:call amc#win#smartFugitive()<CR>
nm	<silent>	<Leader>o	:call amc#win#goHomeOrNext()<CR>
nm	<silent>	<Leader>O	:call amc#win#goHome()<CR>
nm	<silent>	<Leader>q	:q<CR>:call amc#win#goHome()<CR>

nm	<silent>	<Leader>.	:lua vim.diagnostic.goto_next({wrap = false})<CR>
nm	<silent>	<Leader>e	:if amc#qf#setGrepPattern() <Bar> set hlsearch <Bar> endif <Bar> cnext<CR>
" j gitsigns.next_hunk

nm	<silent>	<Leader>p	:lua vim.diagnostic.goto_prev({wrap = false})<CR>
nm	<silent>	<Leader>u	:if amc#qf#setGrepPattern() <Bar> set hlsearch <Bar> endif <Bar> cprev<CR>
" k gitsigns.prev_hunk

nm	<silent>	<Leader>y	:call amc#win#goHome() <Bar> TagbarOpen fj<CR>
nm	<silent>	<Leader>Y	:TagbarClose<CR>
nm	<silent>	<Leader>i	:call amc#win#goHome() <Bar> :lua require('telescope.builtin').buffers()<CR>
nm	<silent>	<Leader>x	:lua require('amc/buf').safe_hash()<CR>

nm	<silent>	<Space><BS>	:call amc#back()<CR>
nm	<silent>	<BS><BS>	:call amc#back()<CR>
" end left

" begin right
nm	<silent>	<Leader>f	:call amc#win#goHome() <Bar> :lua require('telescope.builtin').find_files()<CR>
nm	<silent>	<Leader>F	:call amc#win#goHome() <Bar> :lua require('telescope.builtin').git_status()<CR>
nm	<silent>	<Leader>da	:lua vim.lsp.buf.code_action()<CR>
nm	<silent>	<Leader>dq	:lua vim.diagnostic.setqflist()<CR>
nm	<silent>	<Leader>df	:lua vim.diagnostic.open_float()<CR>
nm	<silent>	<Leader>dh	:lua vim.lsp.buf.hover()<CR>
nm	<silent>	<Leader>dr	:lua vim.lsp.buf.rename()<CR>
nm	<silent>	<Leader>b	<Plug>BufKillBw
nm	<silent>	<Leader>B	<Plug>BufKillBangBw

nm				<Leader>g	:ag "<C-r>=expand('<cword>')<CR>"
nm				<Leader>G	:ag "<C-r>=expand('<cWORD>')<CR>"
vm				<Leader>g	"*y<Esc>:<C-u>ag "<C-r>=getreg("*")<CR>"
nm	<silent>	<Leader>hb	:G blame<CR>
" h* gitsigns
nm	<silent>	<Leader>ma	:make all <Bar> call amc#qf#openJump()<CR>
nm	<silent>	<Leader>mc	:make clean <Bar> call amc#qf#openJump()<CR>
nm	<silent>	<Leader>mm	:make <Bar> call amc#qf#openJump()<CR>
nm	<silent>	<Leader>mn	:!rm -rf build ; meson build <CR>
nm	<silent>	<Leader>mt	:make test <Bar> call amc#qf#openJump()<CR>

nm	<silent>	<Leader>cu	<Plug>Commentary<Plug>Commentary
nm	<silent>	<Leader>cc	<Plug>CommentaryLine
om	<silent>	<Leader>c	<Plug>Commentary
nm	<silent>	<Leader>c	<Plug>Commentary
xm	<silent>	<Leader>c	<Plug>Commentary
nm	<silent>	<Leader>t	:lua require('amc/plugins/lsp').goto_definition_or_tag()<CR>
nm	<silent>	<Leader>T	:lua vim.lsp.buf.declaration()<CR>
nm	<silent>	<Leader>w	<Plug>ReplaceWithRegisterOperatoriw
xm	<silent>	<Leader>w	<Plug>ReplaceWithRegisterVisual
nm	<silent>	<Leader>W	<Plug>ReplaceWithRegisterLine

nm				<Leader>r	:%s/<C-r>=expand('<cword>')<CR>/
nm				<Leader>R	:%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>
vm				<Leader>r	"*y<Esc>:%s/<C-r>=getreg("*")<CR>/
vm				<Leader>R	"*y<Esc>:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>
nm	<silent>	<Leader>n	:lua require('telescope.builtin').lsp_references()<CR>
nm	<silent>	<Leader>v	:put<CR>'[v']=
nm	<silent>	<Leader>V	:put!<CR>'[v']=

nm	<silent>	<Leader>l	:syntax match TrailingSpace /\s\+$/<CR>
nm	<silent>	<Leader>L	:syntax clear TrailingSpace<CR>
nm	<silent>	<Leader>s	:GotoHeaderSwitch<CR>
nm	<silent>	<Leader>S	:GotoHeader<CR>
nm	<silent>	<Leader>z	gg=G``

nm				<Leader>/	/<C-r>=expand("<cword>")<CR><CR>
vm				<Leader>/	"*y<Esc>/<C-u><C-r>=getreg("*")<CR><CR>
" -
nm	<silent>	<Leader>\	gg"_dG

nm	<silent>	<BS><Space>	:call amc#forward()<CR>
nm	<silent>	<Space><Space>	:call amc#forward()<CR>
" end right
endfor

cm		<C-j>	<Down>
cm		<C-k>	<Up>

" hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
vm <LeftRelease> "*ygv

" no way to remap fugitive and tpope will not add
function s:fugitive_map()
	nm <buffer>t =
	nm <buffer>x X
endfunction
autocmd FileType fugitive call <SID>fugitive_map()

" vim-vsnip
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
