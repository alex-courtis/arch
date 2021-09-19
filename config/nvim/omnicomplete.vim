" omnicompletion
"   inspired by https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"
set completeopt=menuone,longest

" sometimes terminal sends C-Space as Nul, so map it
ino	<expr>	<Nul>		OmniBegin()
ino	<expr>	<C-Space>	OmniBegin()
ino	<expr>	<C-n>		OmniNext()
ino	<expr>	<C-x><C-o>	OmniBegin()
ino	<expr>	<CR>		OmniMaybeSelectFirstAndAccept()
ino	<expr>	<Tab>		pumvisible() ? "\<C-n>" : "\<Tab>"
ino	<expr>	<S-Tab>		pumvisible() ? "\<C-p>" : "\<S-Tab>"

autocmd CompleteDone * call OmniEnd()

" turn off ignore case, as mixed case matches result in longest length 0
function! OmniBegin()
	set noignorecase
	return "\<C-x>\<C-o>\<C-n>"
endfunction

function! OmniNext()
	return "\<C-n>\<C-n>"
endfunction

" turn on ignore case
function! OmniEnd()
	set ignorecase
endfunction

function! OmniMaybeSelectFirstAndAccept()
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
"
" omnicompletion

