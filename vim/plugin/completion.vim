" omnicompletion
"   inspired by https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"
set completeopt=menuone,longest

if has('nvim')
	ino	<expr>	<C-Space>	completion#OmniBegin()
else
	ino	<expr>	<C-@>		completion#OmniBegin()
endif
ino	<expr>	<C-n>		completion#NextBegin()
ino	<expr>	<C-x><C-o>	completion#OmniBegin()
ino	<expr>	<CR>		completion#MaybeSelectFirstAndAccept()
ino	<expr>	<Tab>		pumvisible() ? "\<C-n>" : "\<Tab>"
ino	<expr>	<S-Tab>		pumvisible() ? "\<C-p>" : "\<S-Tab>"

autocmd CompleteDone * call completion#End()

" turn off ignore case, as mixed case matches result in longest length 0
function! completion#OmniBegin()
	set noignorecase
	return "\<C-x>\<C-o>\<C-n>"
endfunction

function! completion#NextBegin()
	return "\<C-n>\<C-n>"
endfunction

" turn on ignore case
function! completion#End()
	set ignorecase
endfunction

function! completion#MaybeSelectFirstAndAccept()
	if pumvisible()
		let ci=complete_info()
		if !empty(ci) && !empty(ci.items)
			if ci.selected == -1
				return "\<C-n>\<C-y>"
			else
				return "\<C-y>"
			endif
		endif
	endif
	return "\<CR>"
endfunction

