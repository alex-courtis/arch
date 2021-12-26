function! amc#mru#prn(msg)
	let l:buf = a:msg . " [ "
	for l:i in w:amcMru
		let l:buf .= bufname(l:i)
		let l:pad = 3
		if l:i == bufnr("#")
			let l:buf .= "#"
			let l:pad -= 1
		endif
		for l:j in range(0, l:pad - 1)
			let l:buf .= " "
		endfor
	endfor
	let l:buf .= "]"

	let l:buf .= "   ( "
	for l:i in w:amcMruWin
		let l:buf .= bufname(l:i)
		let l:pad = 3
		if l:i == bufnr("#")
			let l:buf .= "#"
			let l:pad -= 1
		endif
		if index(w:amcMruWin, l:i) == w:amcMruWinP
			let l:buf .= "p"
			let l:pad -= 1
		endif
		for l:j in range(0, l:pad - 1)
			let l:buf .= " "
		endfor
	endfor
	let l:buf .= ")"

	call amc#log(l:buf)
endfunction

function! amc#mru#bufEnter()
	if !exists("w:amcMru")
		let w:amcMru = []
		let w:amcMruWin = []
		let w:amcMruWinP = 0
	endif

	let l:bn = bufnr()
	let l:bname = bufname()

	if &buftype != "" || !&buflisted || (l:bname != "" && !filereadable(l:bname))
		return
	endif

	call amc#mru#prn("enter")

	let l:bwi = index(w:amcMruWin, l:bn)
	if l:bwi == w:amcMruWinP - 1 || l:bwi == w:amcMruWinP + 1
		" update the window pointer
		let w:amcMruWinP = l:bwi
	else
		" clear window as not traversing
		let w:amcMruWin = []
		let w:amcMruWinP = 0
	endif

	" update the real MRU
	let l:bi = index(w:amcMru, l:bn)
	if l:bi >= 0
		call remove(w:amcMru, l:bi)
	endif
	call add(w:amcMru, l:bn)

	call amc#mru#prn("enter")
endfunction

function! amc#mru#back()
	call amc#mru#prn("back ")

	if len(w:amcMru) < 2
		return
	endif

	if empty(w:amcMruWin)
		let w:amcMruWin = copy(w:amcMru)
		let w:amcMruWinP = len(w:amcMru) - 1
	endif

	if w:amcMruWinP < 1
		return
	endif

	call amc#mru#prn("back ")

	" bufEnter will update the pointer
	exec "b" . w:amcMruWin[w:amcMruWinP - 1]
endfunction

function! amc#mru#forward()
	call amc#mru#prn("forw ")

	if empty(w:amcMruWin)
		return
	endif

	if w:amcMruWinP > len(w:amcMruWin) - 2
		return
	endif

	call amc#mru#prn("forw ")

	" bufEnter will update the pointer
	exec "b" . w:amcMruWin[w:amcMruWinP + 1]
endfunction

