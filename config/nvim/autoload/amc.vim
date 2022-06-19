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


function amc#showTrailingSpaces()	      
	highlight TrailingSpace ctermbg=9 guibg=red
	syntax clear TrailingSpace
	syntax match TrailingSpace /\s\+$/
endfunction

function amc#updateTitleString()
	if &modifiable && &buflisted && strlen(&buftype) == 0 && filereadable(bufname())
		let &titlestring = system('printtermtitle') . ' %m'
	else
		let &titlestring = system('printtermtitle')
	endif
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


function! amc#wipeMacros()
	let l:regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"'
	let l:i = 0 
	while (l:i < strlen(regs)) 
		call setreg(l:regs[l:i], [])
		let l:i += 1 
	endwhile 
endfunction


function! amc#find()
	call amc#win#goHome()

	let l:fn = input("find: ", "", "file_in_path")
	if l:fn == ""
		return
	endif

	try
		execute "silent find " . l:fn
	catch
		echo " not found"
	endtry
endfunction


function amc#back()
	let ts = gettagstack()
	if ts.length > 0 && ts.curidx > ts.length
		pop
	else
		silent execute ":BB"
	endif
	call settagstack(win_getid(), {'items' : []})
endfunction

function amc#forward()
	silent execute ":BF"
	call settagstack(win_getid(), {'items' : []})
endfunction


function amc#grep(...)
	let l:cmd = "silent grep!"

	" Escape all cmdline-special. There is no nice function for this.
	for l:arg in a:000
		let l:arg = substitute(l:arg, '#', '\\#', "g")
		let l:arg = substitute(l:arg, '%', '\\%', "g")
		let l:cmd = l:cmd . " " . l:arg
	endfor

	echo l:cmd
	execute l:cmd

	call amc#qf#openJump()
endfunction

