" update @/ with the grep query, if present
function amc#qf#setGrepPattern()
	let l:context = getqflist({"context" : 0})["context"]
	if type(l:context) == v:t_dict && has_key(l:context, "grepPattern")
		let @/ = l:context["grepPattern"]
	endif
endfunction

function amc#qf#processGrep()
	let l:title = getqflist({"title" : 0}).title
	let l:firstValid = 0
	let l:validItemNr = 0
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

		let l:validItemNr += 1
		if !l:firstValid
			let l:firstValid = l:validItemNr
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

	return l:firstValid
endfunction

function amc#qf#filterResults()
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
		if l:item["valid"] && l:bufnr > 0 && !filereadable(l:bname)
			if bufnr(l:bufnr) != -1
				exec "bw" . l:bufnr
			endif
			let l:item["text"] = l:bname . ":" . l:item["lnum"] . ":" . l:item["text"]
			let l:item["bufnr"] = 0
			let l:item["col"] = 0
			let l:item["lnum"] = 0
			let l:item["valid"] = 0
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
	if match(l:title, ':\s*' . &grepprg . '\s*') >= 0
		call amc#qf#processGrep()
	endif

	let l:firstValid = amc#qf#filterResults()

	call amc#win#goHome()
	cclose
	belowright cwindow 15

	if l:firstValid
		execute "cc" . l:firstValid
	endif
endfunction

