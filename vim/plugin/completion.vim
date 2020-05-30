" omnicompletion
"   inspired by https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"
set completeopt=menuone,longest

ino	<expr>	<C-@>		completion#OmniBegin()
ino	<expr>	<C-x><C-o>	completion#OmniBegin()
ino	<expr>	<CR>		completion#MaybeSelectFirstAndAccept()
ino	<expr>	<Tab>		pumvisible() ? "\<C-n>" : "\<Tab>"
ino	<expr>	<S-Tab>		pumvisible() ? "\<C-p>" : "\<S-Tab>"

autocmd CompleteDone * call completion#OmniEnd()

" turn off ignore case, as mixed case matches result in longest length 0
function! completion#OmniBegin()
	set noignorecase
	let w:completing=1
	return "\<C-x>\<C-o>"
endfunction

" turn on ignore case
function! completion#OmniEnd()
	set ignorecase
	let w:completing=0
endfunction

function! completion#MaybeSelectFirstAndAccept()
	if exists('w:completing') && w:completing && pumvisible()
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

