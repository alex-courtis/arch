function amc#nt#stdinReadPre()
	let g:amc#nt#stdin = 1
endfunction

" from the nerdtree readme, but much less cryptic
function amc#nt#vimEnter()
	if g:amc#nt#stdin
		return
	endif

	if argc() == 0

		" open if nothing specified
		NERDTree
		wincmd p

	elseif argc() == 1 && isdirectory(argv()[0])

		" change to and open the one and only directory
		execute "NERDTree " . argv()[0]
		wincmd p
		enew
		execute "cd " . argv()[0]
		call amc#setPathCwd()

	elseif argc() > 1

		" bomb out if any other directory specified
		for l:i in range(0, argc() - 1)
			if isdirectory(argv()[i - 1])
				exit!
			endif
		endfor
	endif
endfunction

" file under cwd: cd and find it, leave focus in tree, return 1
" other file: if tree at cwd, clear selection, return 0
" other buf: do nothing, return 0
" must have BufEnter events temporarily disabled
function amc#nt#reveal()
	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
		let l:bpath = expand("%:p")
		let l:cwdpre = "^" . getcwd() . "/"

		if match(l:bpath, l:cwdpre) == 0
			NERDTreeCWD
			execute "NERDTreeFind " . substitute(l:bpath, l:cwdpre, "", "")
			return 1
		else
			NERDTreeFocus
			let l:cwdnt = g:NERDTreePath.New(getcwd())
			if b:NERDTree.root.path.equals(l:cwdnt)
				call b:NERDTree.render()
				call b:NERDTree.root.putCursorHere(0, 0)
			endif
			wincmd p
			return 0
		endif
	endif
	return 0
endfunction

function amc#nt#smartFocus()
	let l:eiprev=&ei
	let &ei="BufEnter," . l:eiprev

	if g:NERDTree.IsOpen()
		NERDTreeFocus
	elseif !amc#nt#reveal()
		NERDTree
	endif

	call amc#updateTitleString()
	let &ei=l:eiprev
endfunction

function amc#nt#smartFind()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
		NERDTreeFind
	endif

	call amc#updateTitleString()
	let &ei=l:eiprev
endfunction

function amc#nt#sync()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if g:NERDTree.IsOpen() && amc#nt#reveal()
		wincmd p
	endif

	let &ei=l:eiprev
endfunction

