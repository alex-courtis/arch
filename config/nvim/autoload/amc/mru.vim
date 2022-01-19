let s:colWidth = 28
let s:colPad = " || "
let s:colEmpty = repeat(" ", s:colWidth)
function! amc#mru#stripPad(line)
	let l:line = a:line
	let l:line = l:line[0 : s:colWidth - 1]
	let l:line .= repeat(" ", s:colWidth - len(l:line))
	return l:line
endfunction

function! amc#mru#prn(msg)
	if !g:amcLogMru || !g:amcLog
		return
	endif

	redir => l:buffers
	silent buffers!
	redir END
	let l:bufLines = []
	for l:line in split(l:buffers, '\n')
		let l:stripped = l:line
		let l:stripped = substitute(l:stripped, " *line.*", "", "g")
		let l:stripped = substitute(l:stripped, '"', "", "g")
		let l:stripped = amc#mru#stripPad(l:stripped)
		call add(l:bufLines, l:stripped)
	endfor

	let l:mruLines = []
	for l:i in w:amcMru
		let l:line = l:i . " "
		if l:i == bufnr("#")
			let l:line .= "#"
		else
			let l:line .= " "
		endif
		if l:i == bufnr("%")
			let l:line .= "%"
		else
			let l:line .= " "
		endif
		let l:line .= " "
		let l:name = bufname(l:i)
		if strlen(l:name) == 0
			let l:name = "[No Name]"
		endif
		let l:line .= l:name
		let l:line = amc#mru#stripPad(l:line)
		call add(l:mruLines, l:line)
	endfor

	let l:winLines = []
	for l:i in w:amcMruWin
		let l:line = l:i . " "
		if index(w:amcMruWin, l:i) == w:amcMruWinP
			let l:line .= ">"
		else
			let l:line .= " "
		endif
		if l:i == bufnr("#")
			let l:line .= "#"
		else
			let l:line .= " "
		endif
		if l:i == bufnr("%")
			let l:line .= "%"
		else
			let l:line .= " "
		endif
		let l:line .= " "
		let l:name = bufname(l:i)
		if strlen(l:name) == 0
			let l:name = "[No Name]"
		endif
		let l:line .= l:name
		let l:line = amc#mru#stripPad(l:line)
		call add(l:winLines, l:line)
	endfor

	call amc#log(a:msg)
	for l:i in range(0, max([len(l:bufLines), len(l:mruLines), len(l:winLines)]) - 1)
		let l:line = ""

		if i < len(l:bufLines)
			let l:line .= l:bufLines[i]
		else
			let l:line .= s:colEmpty
		endif
		let l:line .= s:colPad

		if i < len(l:mruLines)
			let l:line .= l:mruLines[i]
		else
			let l:line .= s:colEmpty
		endif
		let l:line .= s:colPad

		if i < len(l:winLines)
			let l:line .= l:winLines[i]
		else
			let l:line .= s:colEmpty
		endif

		let l:line = substitute(l:line, " *$", "", "g")
		call amc#log(l:line)
	endfor
endfunction

" idempotent
function! amc#mru#update()
	if !exists("w:amcMru")
		let w:amcMru = []
		let w:amcMruWin = []
		let w:amcMruWinP = 0
	endif

	let l:bn = bufnr()
	if amc#buf#flavour(l:bn) == g:amc#buf#SPECIAL
		return 0
	endif

	" clear wiped buffers
	for l:i in w:amcMru
		if bufnr(l:i) < 0
			let l:bi = index(w:amcMru, l:i)
			if l:bi >= 0
				call remove(w:amcMru, l:bi)
			endif
			let l:bi = index(w:amcMruWin, l:i)
			if l:bi >= 0
				call remove(w:amcMruWin, l:bi)
			endif
		endif
	endfor

	let l:bwi = index(w:amcMruWin, l:bn)
	if l:bwi != -1 && l:bwi >= w:amcMruWinP - 1 && l:bwi <= w:amcMruWinP + 1
		" update the window pointer
		let w:amcMruWinP = l:bwi
	else
		" clear window as not traversing
		let w:amcMruWin = []
		let w:amcMruWinP = 0
	endif

	" send to front of MRU
	let l:bi = index(w:amcMru, l:bn)
	if l:bi >= 0
		call remove(w:amcMru, l:bi)
	endif
	call add(w:amcMru, l:bn)

	return 1
endfunction

function! amc#mru#bufEnter()
	call amc#mru#update()
	call amc#mru#prn("mru enter:  ")
endfunction

function! amc#mru#back()
	call amc#mru#prn("mru: back")
	let l:flavour = amc#buf#flavour(bufnr())

	if len(w:amcMru) < 2 && l:flavour != g:amc#buf#SPECIAL
		return
	endif

	if empty(w:amcMruWin)
		let w:amcMruWin = copy(w:amcMru)
		let w:amcMruWinP = len(w:amcMru) - 1
	endif

	if l:flavour == g:amc#buf#SPECIAL
		let w:amcMruWinP += 1
	endif

	if w:amcMruWinP < 1
		return
	endif

	exec "b!" . w:amcMruWin[w:amcMruWinP - 1]
endfunction

function! amc#mru#forward()
	call amc#mru#prn("mru: forw")

	if empty(w:amcMruWin)
		return
	endif

	if w:amcMruWinP > len(w:amcMruWin) - 2
		return
	endif

	exec "b!" . w:amcMruWin[w:amcMruWinP + 1]
endfunction

function! amc#mru#winRemove()
	call amc#mru#prn("mru: remove")

	let l:bn = bufnr()
	if len(w:amcMru) > 2
		if empty(w:amcMruWin)
			let w:amcMruWin = copy(w:amcMru)
			let w:amcMruWinP = len(w:amcMru) - 1
		endif

		" send to back of MRU win
		let l:bi = index(w:amcMruWin, l:bn)
		if l:bi >= 0
			call remove(w:amcMruWin, l:bi)
		endif
		call insert(w:amcMruWin, l:bn)

		" tell back to go to the replacement of the removed
		let w:amcMruWinP += 1

		" send to back of MRU
		let l:bi = index(w:amcMru, l:bn)
		if l:bi >= 0
			call remove(w:amcMru, l:bi)
		endif
		call insert(w:amcMru, l:bn)

		" new #
		call amc#mru#back()
		call amc#mru#back()

		" new %
		call amc#mru#forward()
	elseif len(w:amcMru) > 1

		" swap to only other in MRU
		exec "b!" . w:amcMru[0]
	else
		" no other buffers, do nothing
	endif
endfunction

function! amc#mru#winNew()
	let l:pwn = winnr("#")

	let l:amcMru = getwinvar(l:pwn, "amcMru")
	let l:amcMruWin = getwinvar(l:pwn, "amcMruWin")
	let l:amcMruWinP = getwinvar(l:pwn, "amcMruWinP")
	if len(l:amcMru)
		let w:amcMru = deepcopy(l:amcMru)
		let w:amcMruWin = deepcopy(l:amcMruWin)
		let w:amcMruWinP = l:amcMruWinP
	endif
endfunction
