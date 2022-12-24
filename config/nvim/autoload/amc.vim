function amc#colourString(group)
	redir => l:cs
	execute "silent highlight " . a:group
	redir END
	return substitute(l:cs, ".*xxx *", "", "")
endfunction

function amc#colours()
	highlight TrailingSpace ctermbg=9 guibg=red
	highlight CursorLineNr cterm=bold
	highlight default link NvimTreeWindowPicker IncSearch

	" swap these two
	let l:Search = amc#colourString("Search")
	let l:IncSearch = amc#colourString("IncSearch")
	execute "highlight IncSearch " . l:Search
	execute "highlight Search " . l:IncSearch
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


function! amc#airlineStatusLine(...)
	let l:builder = a:1
	let l:context = a:2

	if getbufvar(l:context.bufnr, "&filetype") == 'NvimTree'
		call l:builder.add_section_spaced('airline_a', 'NvimTree')
		call l:builder.add_section('airline_c', '')
		return 1
	endif

	return 0
endfunction

