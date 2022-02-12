" nvim only

" BUG: many files highlighted when using update_focused_file
"
" BUG: find file in closed directory shows hidden; other similar cases e.g. up from directory
" f src/cfg.cpp
"
" BUG: action_cb not being merged when custom_only
"
" BUG: first open from local cwd changes root up but not local cwd, only for vim.g.nvim_tree_change_dir_global
" open
" cd to subdir
"   local cwd is subdir
" edit file
"   tree changed back to global cwd, but local cwd is subdir
" cd to another subdir
" edit file
"   no change
"
" FEATURE: update_focused_file.ignore_list for all

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

function amc#nvt#startup()
	if amc#buf#flavour(bufnr()) == g:amc#buf#NO_NAME_NEW
		NvimTreeOpen

		" events aren't fired within VimEnter so manually clasify
		call amc#win#markSpecial()
	endif
endfunction

" only to workaround above bugs
function amc#nvt#sync()
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

