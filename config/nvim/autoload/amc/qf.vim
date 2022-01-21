" update @/ with the grep query, if present
function! amc#qf#setGrepPattern()
	let l:context = getqflist({"context" : 0}).context
	if strlen(l:context) > 0
		let @/ = l:context
	endif
endfunction

function! amc#qf#processGrep()
	let l:title = getqflist({"title" : 0}).title
	if match(l:title, ':\s*' . &grepprg . '\s*') < 0
		return
	endif

	let l:filteredItems = []
	let l:query = ""
	let l:error = 0
	for l:item in getqflist()

		" query is the only module; remove from list
		if strlen(l:item["module"]) > 0
			let l:query = l:item["module"]
			continue
		endif

		" any error
		if match(l:item["text"], "Error ") >= 0
			let l:error = 1
		endif

		" everything else is real, including errors
		call add(l:filteredItems, l:item)
	endfor
	call setqflist(l:filteredItems, 'r')

	" use query as the context
	if !l:error && strlen(l:query) > 0
		call setqflist([], 'r', {'context': l:query})
		call amc#qf#setGrepPattern()
	endif

	" title is changed to ":setqflist()" after setting items
	call setqflist([], 'r', {'title': l:title})
endfunction

function! amc#qf#processMake()
	let l:title = getqflist({"title" : 0}).title
	if match(l:title, ':\s*' . &makeprg . '\s*') < 0
		return
	endif

	let l:itemNr = 0
	let l:filteredItems = []
	for l:item in getqflist()
		let l:itemNr += 1
		let l:bufnr = l:item["bufnr"]
		let l:bname = bufname(l:bufnr)

		" kill the buffer and invalidate for file that does not exist
		if l:item["valid"] && l:bufnr > 0 && !filereadable(l:bname)
			exec "bw" . l:bufnr
			let l:item["text"] = l:bname . ":" . l:item["lnum"] . ":" . l:item["text"]
			let l:item["bufnr"] = 0
			let l:item["col"] = 0
			let l:item["lnum"] = 0
			let l:item["valid"] = 0
		endif

		call add(l:filteredItems, l:item)
	endfor
	call setqflist(l:filteredItems, 'r')

	" title is changed to ":setqflist()" after setting items
	call setqflist([], 'r', {'title': l:title})
endfunction

function! amc#qf#cmdPost()
	call amc#qf#processGrep()
	call amc#qf#processMake()
	call amc#win#goHome()
	cclose
	aboveleft cwindow 15
endfunction

