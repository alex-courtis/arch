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

	elseif argc() == 1 && isdirectory(argv()[0])

		" change to and open the one and only directory
		execute "NERDTree " . argv()[0]
		wincmd p
		enew
		execute "cd " . argv()[0]
		execute "NERDTreeFocus"

	elseif argc() > 1

		" bomb out if any other directory specified
		for l:i in range(0, argc() - 1)
			if isdirectory(argv()[i - 1])
				exit!
			endif
		endfor
	endif
endfunction

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

		" strip leading CWD for absolutely pathed files
		let l:bname = substitute(bufname(), "^" . getcwd() . "/", "", "")

		if l:bname[0] != "/" && match(l:bname, "^\\.\\.") != 0

			" leading ./ confuses nerdtree
			let l:bname = substitute(l:bname, "^\\./", "", "")
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

	call amc#updatetitlestring()
	let &ei=l:eiprev
endfunction

function amc#nt#smartFind()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if amc#nt#findableBuf()
		NERDTreeFind
	endif

	call amc#updatetitlestring()
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

