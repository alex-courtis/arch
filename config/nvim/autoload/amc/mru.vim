function amc#mru#initWinVars()
	if !exists("w:amcMru")
		let w:amcMru = []
	endif
	if !exists("w:amcMruWin")
		let w:amcMruWin = []
	endif
	if !exists("w:amcMruWinP")
		let w:amcMruWinP = -1
	endif
endfunction

function amc#mru#prn(msg, full)
	if !exists('g:amcLogMru') || !g:amcLogMru
		return
	endif

	if !a:full
		call amc#log#_line(a:msg)
		return
	endif

	call amc#mru#initWinVars()

	let l:bnCur = bufnr("%")
	let l:bnAlt = bufnr("#")
	if len(w:amcMruWin) > 0
		let l:bnPtr = w:amcMruWin[w:amcMruWinP]
	else
		let l:bnPtr = -1
	endif

	redir => l:buffers
	silent buffers!
	redir END
	let l:bufLines = []
	for l:line in split(l:buffers, '\n')
		let l:stripped = l:line
		let l:stripped = substitute(l:stripped, " *line.*", "", "g")
		let l:stripped = substitute(l:stripped, '"', "", "g")
		call add(l:bufLines, l:stripped)
	endfor

	let l:mruLines = []
	for l:bn in w:amcMru
		let l:bname = bufname(l:bn)
		let l:line = printf("%2d %s %s",
					\ l:bn,
					\ l:bn == l:bnCur ? "%" : l:bn == l:bnAlt ? "#" : " ",
					\ strlen(l:bname) == 0 ? "[No Name]" : l:bname)
		call add(l:mruLines, l:line)
	endfor

	let l:winLines = []
	for l:bn in w:amcMruWin
		let l:bname = bufname(l:bn)
		let l:line = printf("%2d %s%s %s",
					\ l:bn,
					\ l:bn == l:bnPtr ? ">" : " ",
					\ l:bn == l:bnCur ? "%" : l:bn == l:bnAlt ? "#" : " ",
					\ strlen(l:bname) == 0 ? "[No Name]" : l:bname)
		call add(l:winLines, l:line)
	endfor

	let l:all = a:msg
	for l:i in range(0, max([len(l:bufLines), len(l:mruLines), len(l:winLines)]) - 1)
		let l:all .= printf("\n%-40.40s | %-36.36s | %.37s",
					\ i < len(l:bufLines) ? l:bufLines[i] : "",
					\ i < len(l:mruLines) ? l:mruLines[i] : "",
					\ i < len(l:winLines) ? l:winLines[i] : "")
	endfor
	call amc#log#_line(l:all)
endfunction

" idempotent
function amc#mru#update()
	call amc#mru#initWinVars()

	let l:bn = bufnr()

	" clear on any special but BufExplorer
	if exists('w:amcSpecial') && w:amcSpecial
		if w:amcSpecial == g:amc#buf#BUF_EXPLORER
			call amc#log#line("amc#mru#update ignoring BUF_EXPLORER")
		else
			call amc#log#line("amc#mru#update clearing MRU for special")
			let w:amcMru = []
			let w:amcMruWin = []
			let w:amcMruWinP = -1
		endif
		call amc#mru#prn("mru: update special", 1)
		return 0
	endif

	" clear wiped buffers
	for l:i in w:amcMru
		if bufnr(l:i) < 0
			let l:bi = index(w:amcMru, l:i)
			if l:bi >= 0
				call amc#log#line("amc#mru#update removing from Mru")
				call remove(w:amcMru, l:bi)
			endif
			let l:bi = index(w:amcMruWin, l:i)
			if l:bi >= 0
				call amc#log#line("amc#mru#update removing from MruWin")
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

	call amc#mru#prn("mru: update", 1)
	return 1
endfunction

function amc#mru#back()
	call amc#mru#prn("mru: back", 0)

	call amc#mru#initWinVars()

	let l:special = amc#buf#isSpecial(bufnr())

	if len(w:amcMru) < 2 && l:special
		return
	endif

	if empty(w:amcMruWin)
		let w:amcMruWin = copy(w:amcMru)
		let w:amcMruWinP = len(w:amcMru) - 1
	endif

	if l:special
		let w:amcMruWinP += 1
	endif

	if w:amcMruWinP < 1
		return
	endif

	exec "b!" . w:amcMruWin[w:amcMruWinP - 1]
endfunction

function amc#mru#forward()
	call amc#mru#prn("mru: forw", 0)

	call amc#mru#initWinVars()

	if empty(w:amcMruWin)
		return
	endif

	if w:amcMruWinP > len(w:amcMruWin) - 2
		return
	endif

	exec "b!" . w:amcMruWin[w:amcMruWinP + 1]
endfunction

function amc#mru#winRemove()
	call amc#mru#prn("mru: remove " . winnr(), 0)

	let l:bn = bufnr()

	if amc#buf#isSpecial(l:bn)
		return
	endif

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

function amc#mru#winNew()
	call amc#mru#initWinVars()

	" optimistically clone from the old window; it will be cleared on special BufEnter
	let l:pwn = winnr("#")
	let l:amcMru = getwinvar(l:pwn, "amcMru")
	let l:amcMruWin = getwinvar(l:pwn, "amcMruWin")
	let l:amcMruWinP = getwinvar(l:pwn, "amcMruWinP")
	if len(l:amcMru)
		call amc#log#line("amc#mru#winNew cloning MRU")
		let w:amcMru = deepcopy(l:amcMru)
		if len(l:amcMruWin)
			let w:amcMruWin = deepcopy(l:amcMruWin)
			let w:amcMruWinP = l:amcMruWinP
		endif
	endif
endfunction

