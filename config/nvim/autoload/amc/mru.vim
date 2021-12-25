function! amc#mru#bufEnter()
	if !exists('w:mru')
		let w:mru = []
	endif

	let l:bn = bufnr()
	let l:bname = bufname()

	if &buftype != "" || !&buflisted || (l:bname != "" && !filereadable(l:bname))
		call amc#log("be returning early")
		echo "be returning early"
		return
	endif

	let l:bi = index(w:mru, l:bn)
	if l:bi >= 0 && (l:bi == w:mrup - 1  || l:bi == w:mrup + 1)
		let w:mrup = l:bi
	else
		if (l:bi >= 0)
			call remove(w:mru, l:bi)
		endif
		call add(w:mru, l:bn)
		let w:mrup = len(w:mru) - 1
	endif
endfunction

function! amc#mru#back()
	if w:mrup < 1
		return
	endif

	echo string(w:mru) . " (" . w:mru[w:mrup - 1] . " <- " .  w:mru[w:mrup] . ")"
	exec "b" . w:mru[w:mrup - 1]
endfunction

function! amc#mru#forward()
	if w:mrup + 1 >= len(w:mru)
		return
	endif

	echo string(w:mru) . " (" . w:mru[w:mrup + 1] . " <- " .  w:mru[w:mrup] . ")"
	exec "b" . w:mru[w:mrup + 1]
endfunction

