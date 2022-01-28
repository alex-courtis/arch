" nvim only

" BUG: many files highlighted when using update_focused_file

function amc#nvt#setup()
	set termguicolors

	" does not work when set via lua vim.g.
	let g:nvim_tree_show_icons = {
				\ 'git': 1,
				\ 'folders': 0,
				\ 'files': 0,
				\ 'folder_arrows': 0,
				\ }
	lua require 'nvt'
endfunction

function amc#nvt#vimEnter()
	if amc#buf#isNoNameNew(bufnr())
		NvimTreeOpen

		" events aren't fired within VimEnter so manually clasify
		call amc#win#markSpecial()
	endif
endfunction

" only to workaround above bugs
function amc#nvt#bufEnter()
	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
		NvimTreeRefresh
	endif
endfunction

function amc#nvt#smartFocus()
	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
		NvimTreeFindFile
	else
		NvimTreeFocus
	endif
endfunction

