" update @/ with the grep query, if present
function amc#qf#setGrepPattern()
	let l:context = getqflist({"context" : 0})["context"]
	if type(l:context) == v:t_dict && has_key(l:context, "grepPattern")
		let @/ = l:context["grepPattern"]
		return 1
	else
		return 0
	endif
endfunction

" 0 for no results, >0 for first valid, -1 for only invalid
function amc#qf#processGrep()
	let l:title = getqflist({"title" : 0}).title
	let l:firstValid = 0
	let l:firstInvalid = 0
	let l:itemNr = 0
	let l:filteredItems = []
	let l:query = ""
	for l:item in getqflist()

		" query is the only module; remove from list
		if strlen(l:item["module"]) > 0
			let l:query = l:item["module"]
			continue
		endif

		" everything else is real, including errors
		call add(l:filteredItems, l:item)

		let l:itemNr += 1
		if !l:firstValid && l:item["valid"]
			let l:firstValid = l:itemNr
		endif
		if !l:firstInvalid && !l:item["valid"]
			let l:firstInvalid = l:itemNr
		endif
	endfor
	call setqflist(l:filteredItems, 'r')

	" use query as the context
	if strlen(l:query) > 0
		call setqflist([], 'r', { 'context': { 'grepPattern' : l:query } })
		call amc#qf#setGrepPattern()
	endif

	" title is changed to ":setqflist()" after setting items
	call setqflist([], 'r', {'title': l:title})

	if l:firstInvalid && !l:firstValid
		return -1
	else
		return l:firstValid
	endif
endfunction

function amc#qf#processInexistent()
	let l:title = getqflist({"title" : 0}).title
	let l:all = getqflist({'all' : 1})
	let l:all['items'] = []

	let l:firstValid = 0
	let l:itemNr = 0
	let l:filteredItems = []
	for l:item in getqflist()
		let l:itemNr += 1
		let l:bufnr = l:item["bufnr"]
		let l:bname = bufname(l:bufnr)

		" kill the buffer and invalidate for file that does not exist
		if l:item["valid"]
			if l:bufnr > 0 && !filereadable(l:bname)
				if bufnr(l:bufnr) != -1
					exec "bw" . l:bufnr
				endif
				let l:item["text"] = l:bname . ":" . l:item["lnum"] . ":" . l:item["text"]
				let l:item["bufnr"] = 0
				let l:item["col"] = 0
				let l:item["lnum"] = 0
				let l:item["valid"] = 0
			elseif l:bufnr == 0
				let l:item["valid"] = 0
			endif
		endif

		call add(l:filteredItems, l:item)

		if l:item["valid"] && !l:firstValid
			let l:firstValid = l:itemNr
		endif
	endfor
	call setqflist(l:filteredItems, 'r')

	" title is changed to ":setqflist()" after setting items
	call setqflist([], 'r', {'title': l:title})

	return l:firstValid
endfunction

function amc#qf#cmdPost()
	let l:title = getqflist({"title" : 0}).title

	let l:cc = 0
	if match(l:title, ':\s*' . &grepprg . '\s*') >= 0
		call amc#qf#processInexistent()
		let l:cc = amc#qf#processGrep()
	elseif match(l:title, ':\s*' . &makeprg . '\s*') >= 0
		let l:cc = amc#qf#processInexistent()
	endif

	call amc#win#goHome()
	if l:cc == -1
		belowright copen 15
	else
		belowright cwindow 15
	endif

	if l:cc > 0
		execute "cc" . l:cc
	endif
endfunction

