function amc#sourceIfExists(file)
	if filereadable(expand(a:file))
		exe 'source' a:file
	endif
endfunction


function amc#colourString(group)
	redir => l:cs
	execute "silent highlight " . a:group
	redir END
	return substitute(l:cs, ".*xxx *", "", "")
endfunction

function amc#colours()
	highlight CursorLineNr cterm=bold
	highlight default link TagbarHighlight CursorLine
        highlight default link bufExplorerHidBuf Operator
	highlight default link NvimTreeWindowPicker IncSearch

	" swap these two
	let l:Search = amc#colourString("Search")
	let l:IncSearch = amc#colourString("IncSearch")
	execute "highlight IncSearch " . l:Search
	execute "highlight Search " . l:IncSearch
endfunction


function amc#updateTitleString()
	if &modifiable && &buflisted && strlen(&buftype) == 0 && filereadable(bufname())
		let &titlestring = system('printtermtitle') . ' %m'
	else
		let &titlestring = system('printtermtitle')
	endif
endfunction


function amc#vselFirstLine()
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


function amc#linewiseIndent(cmd, repeat)
	let [l:body, l:type] = [getreg(v:register), getregtype(v:register)]
	call setreg(v:register, l:body, 'l')
	execute 'normal! ' . a:cmd . "'[v']="
	call setreg(v:register, l:body, l:type)
	call repeat#set(a:repeat)
endfunction


function! amc#airlineStatusLine(...)
	let l:builder = a:1
	let l:context = a:2

	if !amc#buf#isSpecial(l:context.bufnr)
		let l:special = getwinvar(l:context.winnr, "amcSpecial", 0)
		if l:special
			call l:builder.add_section_spaced('airline_error', g:amc#buf#specialNames[l:special])
		endif
	endif

	if getbufvar(l:context.bufnr, "&filetype") == 'NvimTree'
		call l:builder.add_section_spaced('airline_a', 'NvimTree')
		call l:builder.add_section('airline_c', '')
		return 1
	endif

	return 0
endfunction


function! amc#wipeMacros()
	let l:regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"' 
	let l:i = 0 
	while (l:i < strlen(regs)) 
		call setreg(l:regs[l:i], [])
		let l:i += 1 
	endwhile 
endfunction


function! amc#clear()
	call amc#mru#clear()

	call settagstack(win_getid(), {'items' : []})
endfunction

function! amc#clearDelete()
	call amc#win#goHome()

	call amc#clear()

	for l:bn in range(1, bufnr("$"), 1)
		if l:bn != bufnr("%") && amc#buf#flavour(l:bn) == g:amc#buf#ORDINARY_HAS_FILE && getbufvar(l:bn, "&buflisted")
			" amc#buf#autoWrite will update before delete
			execute "bw!" . l:bn
		endif
	endfor
endfunction

