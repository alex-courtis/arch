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

nm	<silent>	<Leader>:	:cclose<CR>
nm	<silent>	<Leader>;	:copen 15<CR>
nm	<silent>	<Leader>a	:NvimTreeFindFile<CR>:NvimTreeFocus<CR>
nm	<silent>	<Leader>A	:NvimTreeCollapse<CR><Leader>a
nm	<silent>	<Leader>'	:call amc#win#closeInc()<CR>
nm	<silent>	<Leader>"	:lua require('amc.windows').close_others()<CR>

nm	<silent>	<Leader>,	:G<CR>
nm	<silent>	<Leader>o	:lua require('amc.windows').go_home_or_next()<CR>
nm	<silent>	<Leader>O	:lua require('amc.windows').go_home()<CR>
nm	<silent>	<Leader>q	:q<CR>:call amc#win#goHome()<CR>

nm	<silent>	<Leader>.	:lua vim.diagnostic.goto_next({wrap = false})<CR>
nm	<silent>	<Leader>e	:cnext<CR>
" j gitsigns.next_hunk

nm	<silent>	<Leader>p	:lua vim.diagnostic.goto_prev({wrap = false})<CR>
nm	<silent>	<Leader>u	:cprev<CR>
" k gitsigns.prev_hunk

nm	<silent>	<Leader>y	:call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status()<CR>
nm	<silent>	<Leader>Y	:call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status_last()<CR>
nm	<silent>	<Leader>i	:call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').buffers()<CR>
nm	<silent>	<Leader>x	:lua require('amc.buffers').safe_hash()<CR>

nm	<silent>	<Space><BS>	:lua require('amc.buffers').back()<CR>
nm	<silent>	<BS><BS>	:lua require('amc.buffers').back()<CR>
" end left

" begin right
nm	<silent>	<Leader>f	:call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files()<CR>
nm	<silent>	<Leader>F	:call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files_last()<CR>
nm	<silent>	<Leader>da	:lua vim.lsp.buf.code_action()<CR>
nm	<silent>	<Leader>dq	:lua vim.diagnostic.setqflist()<CR>
nm	<silent>	<Leader>df	:lua vim.diagnostic.open_float()<CR>
nm	<silent>	<Leader>dh	:lua vim.lsp.buf.hover()<CR>
nm	<silent>	<Leader>dr	:lua vim.lsp.buf.rename()<CR>
" b

nm	<silent>	<Leader>g	:call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep()<CR>
nm	<silent>	<Leader>G	:call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep_last()<CR>
nm	<silent>	<Leader>hb	:G blame<CR>
" h* gitsigns
nm	<silent>	<Leader>ma	:make all<CR>
nm	<silent>	<Leader>mc	:make clean<CR>
nm	<silent>	<Leader>mm	:make<CR>
nm	<silent>	<Leader>mn	:!rm -rf build ; meson build <CR>
nm	<silent>	<Leader>mt	:make test<CR>

" c* comment
nm	<silent>	<Leader>t	:lua require('amc.plugins.lsp').goto_definition_or_tag()<CR>
nm	<silent>	<Leader>T	:lua vim.lsp.buf.declaration()<CR>
nm	<silent>	<Leader>w	<Plug>ReplaceWithRegisterOperatoriw
xm	<silent>	<Leader>w	<Plug>ReplaceWithRegisterVisual
nm	<silent>	<Leader>W	<Plug>ReplaceWithRegisterLine

nm				<Leader>r	:%s/<C-r>=expand('<cword>')<CR>/
nm				<Leader>R	:%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>
vm				<Leader>r	"*y<Esc>:%s/<C-r>=getreg("*")<CR>/
vm				<Leader>R	"*y<Esc>:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>
nm	<silent>	<Leader>n	:lua require('amc.plugins.telescope').lsp_references()<CR>
nm	<silent>	<Leader>v	:put<CR>'[v']=
nm	<silent>	<Leader>V	:put!<CR>'[v']=

nm	<silent>	<Leader>l	:syntax match TrailingSpace /\s\+$/<CR>
nm	<silent>	<Leader>L	:syntax clear TrailingSpace<CR>
nm				<Leader>s	:lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = "normal" })<CR>
nm				<Leader>S	:lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = "normal" })<CR>
vm				<Leader>s	"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg("*")<CR>' })<CR>"
nm	<silent>	<Leader>z	gg=G``

nm				<Leader>/	/<C-r>=expand("<cword>")<CR><CR>
vm				<Leader>/	"*y<Esc>/<C-u><C-r>=getreg("*")<CR><CR>
nm	<silent>	<Leader>\	gg"_dG

nm	<silent>	<BS><Space>	:lua require('amc.buffers').forward()<CR>
nm	<silent>	<Space><Space>	:lua require('amc.buffers').forward()<CR>
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
