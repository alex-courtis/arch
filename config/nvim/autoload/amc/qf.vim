" update @/ with the grep query, if present
function! amc#qf#setGrepPattern()
	let l:context = getqflist({"context" : 0}).context
	if strlen(l:context) > 0
		let @/ = l:context
	endif
endfunction

function! amc#qf#processGrepQuery()
	let l:title = getqflist({"title" : 0}).title
	let l:size = getqflist({"size" : 0}).size
	if !l:size > 0 || match(l:title, ':\s*' . &grepprg . '\s*') < 0
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

	" use query as the context when no errors
	if !l:error && strlen(l:query) > 0
		call setqflist([], 'r', {'context': l:query})
		" call amc#qf#setGrepPattern()
	endif

	" title is changed to ":setqflist()" after setting items
	call setqflist([], 'r', {'title': l:title})
endfunction

function! amc#qf#cmdPost()
	call amc#qf#processGrepQuery()
	call amc#win#goHome()
	cclose
	aboveleft cwindow 15
endfunction

