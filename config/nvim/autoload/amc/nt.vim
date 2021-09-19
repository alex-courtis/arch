" listed buffer
" 'normal' buffer (buftype empty)
" readable file
function amc#nt#findableBuf()
	return
				\ &buflisted &&
				\ strlen(&buftype) == 0 &&
				\ filereadable(bufname())
endfunction

" file under cwd: cd and find it, leave focus in tree, return 1
" other file: if tree at cwd, clear selection, return 0
" other buf: do nothing, return 0
" must have BufEnter events temporarily disabled
function amc#nt#reveal()
	if amc#nt#findableBuf()
		let l:bname = bufname()
		if l:bname[0] != "/"
			NERDTreeCWD
			execute "NERDTreeFind " . l:bname
			return 1
		else
			NERDTreeFocus
			let l:cwdp = g:NERDTreePath.New(getcwd())
			if b:NERDTree.root.path.equals(l:cwdp)
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

	let &ei=l:eiprev
endfunction

function amc#nt#smartFind()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if amc#nt#findableBuf()
		NERDTreeFind
	endif

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
