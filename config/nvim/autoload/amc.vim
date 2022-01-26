function! amc#sourceIfExists(file)
	if filereadable(expand(a:file))
		exe 'source' a:file
	endif
endfunction


function! amc#colours()
	highlight CursorLineNr cterm=bold
	highlight default link TagbarHighlight CursorLine
        highlight def link bufExplorerHidBuf Operator

	" swap these two
	highlight Search ctermfg=18 ctermbg=16 guifg=#303030 guibg=#fc6d24
	highlight IncSearch ctermfg=18 ctermbg=3 guifg=#303030 guibg=#fda331
endfunction


function! amc#updateTitleString()
	if &modifiable && &buflisted && strlen(&buftype) == 0 && filereadable(bufname())
		let &titlestring = system('printtermtitle') . ' %m'
	else
		let &titlestring = system('printtermtitle')
	endif
endfunction


function! amc#vselFirstLine()
	try
		let l:zprev = @z
		normal! gv"zy
		return substitute(@z, "\n.*", "", "g")
	finally
		let @z = l:zprev
	endtry
endfunction


function amc#startupCwd()
	if argc() == 1 && isdirectory(argv()[0])

		" change to one and only directory
		execute "cd " . argv()[0]
		bw

	elseif argc() > 1

		" bomb out if any other directory specified
		for l:i in range(0, argc() - 1)
			if isdirectory(argv()[i - 1])
				qa!
			endif
		endfor
	endif

	call amc#updatePath()
endfunction

function amc#updatePath()
	let &path = getcwd() . "/**"
endfunction

