function! amc#qf#updateAgPattern()
	if g:amc#qf#aging
		let @/ = substitute(getqflist({"title" : 0}).title, "ag: ", "", "")
	endif
endfunction

function! amc#qf#updateAging()
	let l:title = getqflist({"title" : 0}).title
	let l:size = getqflist({"size" : 0}).size

	let g:amc#qf#aging = l:size > 0 && (match(l:title, "ag: ") == 0 || match(l:title, ':\s*' . &grepprg . '\s*') >= 0)

	call amc#qf#updateAgPattern()
endfunction

function! amc#qf#processAgQuery()
	call amc#qf#updateAging()

	if !g:amc#qf#aging
		return
	endif

	let l:title = getqflist({"title" : 0}).title
	let l:filteredItems = []
	for l:item in getqflist()
		if match(l:item["module"], "BUG") == 0
			" set the title to the query string
			if match(l:item["text"], "Query is ") == 0
				let l:title = substitute(l:item["text"], "Query is ", "ag: ", "")
			endif
		else
			" filter DEBUG: lines
			call add(l:filteredItems, l:item)
		endif
	endfor
	call setqflist(l:filteredItems, 'r')
	call setqflist([], 'r', {'title': l:title})

	" update again, as setqflist items may have triggered updateAging with the
	" intermediate title ":setqflist()"
	call amc#qf#updateAging()
endfunction

function! amc#qf#cmdPost()
	call amc#qf#processAgQuery()
	call amc#win#goHome()
	cclose
	aboveleft cwindow 15
endfunction

