" nerdtree
"
let NERDTreeMinimalUI=1

let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

set wildignore+=*.o,*.class
let NERDTreeRespectWildIgnore=1

autocmd StdinReadPre * let s:std_in=1

" Start NERDTree when Vim is started without any arguments or stdin.
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree when Vim starts with single directory argument and focus it.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
			\ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | execute 'NERDTreeFocus' | endif

" listed buffer
" 'normal' buffer (buftype empty)
" readable file
function NERDTreeFindableBuf()
	return
				\ &buflisted &&
				\ strlen(&buftype) == 0 &&
				\ filereadable(bufname())
endfunction

" file under cwd: cd and find it, leave focus in tree, return 1
" other file: if tree at cwd, clear selection, return 0
" other buf: do nothing, return 0
" must have BufEnter events temporarily disabled
function NERDTreeReveal()
	if NERDTreeFindableBuf()
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

function NERDTreeSmartFocus()
	let l:eiprev=&ei
	let &ei="BufEnter," . l:eiprev

	if g:NERDTree.IsOpen()
		NERDTreeFocus
	elseif !NERDTreeReveal()
		NERDTree
	endif

	let &ei=l:eiprev
endfunction

function NERDTreeSmartFind()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if NERDTreeFindableBuf()
		NERDTreeFind
	endif

	let &ei=l:eiprev
endfunction

function NERDTreeSync()
	let l:eiprev=&ei
	let &ei="BufEnter," . eiprev

	if g:NERDTree.IsOpen() && NERDTreeReveal()
		wincmd p
	endif

	let &ei=l:eiprev
endfunction
autocmd BufEnter * call NERDTreeSync()
"
" nerdtree

