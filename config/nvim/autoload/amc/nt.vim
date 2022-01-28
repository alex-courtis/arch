" vim only

function amc#nt#vimEnter()
	if amc#buf#isNoNameNew(bufnr())
		NERDTreeFocus
	endif
endfunction

" file under cwd: cd and find it, leave focus in tree, return 1
" other file: if tree at cwd, clear selection, return 0
" other buf: do nothing, return 0
function amc#nt#reveal()
	let l:moveToRoot = 0

	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
		let l:bpath = expand("%:p")
		let l:cwdpre = "^" . getcwd() . "/"

		if match(l:bpath, l:cwdpre) == 0
			NERDTreeCWD
			execute "NERDTreeFind " . substitute(l:bpath, l:cwdpre, "", "")
			return 1
		else
			let l:moveToRoot = 1
		endif
	elseif amc#buf#flavour(bufnr()) != g:amc#buf#SPECIAL
		let l:moveToRoot = 1
	endif

	if l:moveToRoot
		NERDTreeFocus
		let l:cwdnt = g:NERDTreePath.New(getcwd())
		if b:NERDTree.root.path.equals(l:cwdnt)
			call b:NERDTree.render()
			call b:NERDTree.root.putCursorHere(0, 0)
		endif
		wincmd p
	endif
	return 0
endfunction

function amc#nt#smartFocus()
	if g:NERDTree.IsOpen()
		NERDTreeFocus
	elseif !amc#nt#reveal()
		NERDTree
	endif

	call amc#updateTitleString()
endfunction

function amc#nt#smartFind()
	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
		NERDTreeFind
	endif

	call amc#updateTitleString()
endfunction

function amc#nt#sync()
	if g:NERDTree.IsOpen() && amc#nt#reveal()
		wincmd p
	endif
endfunction

