"   inspired by https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"

" turn off ignore case, as mixed case matches result in longest length 0
function! amc#omni#begin()
	set noignorecase
	return "\<C-x>\<C-o>\<C-n>"
endfunction

function! amc#omni#next()
	return "\<C-n>\<C-n>"
endfunction

" turn on ignore case
function! amc#omni#end()
	set ignorecase
endfunction

function! amc#omni#maybeSelectFirstAndAccept()
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

