" needed when the quickfix list is twiddled, as the auto jump won't happen
let s:ccJumpTo = 0

function amc#qf#removeInexistent()
	let l:title = getqflist({"title" : 0}).title
	let l:items = getqflist({"items" : 0}).items

	let l:firstValid = 0
	let l:itemNr = 0
	let l:filteredItems = []
	for l:item in l:items
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
	call setqflist([], 'r', {"items": l:filteredItems})

	let s:ccJumpTo = l:firstValid
endfunction

function amc#qf#cmdPostProcess()
	let s:ccJumpTo = 0

	let l:title = getqflist({"title" : 0}).title

	if match(l:title, ':\s*' . &makeprg . '\s*') >= 0
		call amc#qf#removeInexistent()
	endif
endfunction

function amc#qf#openJump()
	lua require('amc/windows').go_home()

	botright cwindow 15

	if s:ccJumpTo
		execute "cc" . s:ccJumpTo
	endif

	let s:ccJumpTo = 0
endfunction

