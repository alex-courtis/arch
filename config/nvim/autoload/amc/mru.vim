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

function amc#mru#prn(msg, echo)
	if !a:echo && (!exists('g:amcLogMru') || !g:amcLogMru)
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
		let l:bname = fnamemodify(bufname(l:bn), ":~")
		let l:line = printf("%2d %s %s",
					\ l:bn,
					\ l:bn == l:bnCur ? "%" : l:bn == l:bnAlt ? "#" : " ",
					\ strlen(l:bname) == 0 ? "[No Name]" : l:bname)
		call add(l:mruLines, l:line)
	endfor

	let l:winLines = []
	for l:bn in w:amcMruWin
		let l:bname = fnamemodify(bufname(l:bn), ":~")
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

	if a:echo
		echo l:all
	else
		call amc#log#_line(l:all)
	endif
endfunction

function amc#mru#update()
	call amc#mru#initWinVars()

	let l:bn = bufnr()

	" clear on any special but BufExplorer
	let l:special = get(w:, 'amcSpecial', 0)
	if !l:special
		let l:special = amc#buf#special(l:bn)
	endif
	if l:special
		if l:special != g:amc#buf#BUF_EXPLORER
			let w:amcMru = []
			let w:amcMruWin = []
			let w:amcMruWinP = -1
		endif
		call amc#mru#prn("mru: updated special", 0)
		return 0
	endif

	" clear window when not traversing
	if w:amcMruWinP != index(w:amcMruWin, l:bn)
		call amc#log#line("amc#mru#update not traversing MruWin, clearing")
		let w:amcMruWin = []
		let w:amcMruWinP = -1
	endif

	" clear wiped / deleted buffers
	for l:i in w:amcMru
		if bufnr(l:i) < 0 || !getbufvar(l:i, "&buflisted")
			let l:bi = index(w:amcMru, l:i)
			if l:bi >= 0
				call amc#log#line("amc#mru#update removing wiped / deleted " . l:i . " from Mru")
				call remove(w:amcMru, l:bi)
			endif
			let l:bi = index(w:amcMruWin, l:i)
			if l:bi >= 0
				call amc#log#line("amc#mru#update removing wiped / deleted " . l:i . " from MruWin")
				call remove(w:amcMruWin, l:bi)
				let w:amcMruWinP -= 1
			endif
		endif
	endfor

	" window needs multiple entries
	if len(w:amcMruWin) < 2
		if len(w:amcMruWin) != 0
			call amc#log#line("amc#mru#update clearing < 2 MruWin")
		endif
		let w:amcMruWin = []
		let w:amcMruWinP = -1
	endif

	" send to front of MRU
	let l:bi = index(w:amcMru, l:bn)
	if l:bi >= 0
		call remove(w:amcMru, l:bi)
	endif
	call add(w:amcMru, l:bn)

	call amc#mru#prn("mru: updated", 0)
	return 1
endfunction

function amc#mru#back()
	call amc#log#line("mru: back")

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

	let w:amcMruWinP -= 1
	exec "b!" . w:amcMruWin[w:amcMruWinP]
endfunction

function amc#mru#forward()
	call amc#log#line("mru: forw")

	call amc#mru#initWinVars()

	if empty(w:amcMruWin)
		return
	endif

	if w:amcMruWinP > len(w:amcMruWin) - 2
		return
	endif

	let w:amcMruWinP += 1
	exec "b!" . w:amcMruWin[w:amcMruWinP]
endfunction

function amc#mru#winRemove()
	let l:bn = bufnr()

	call amc#log#line("mru: remove " . l:bn)

	if amc#buf#isSpecial(l:bn)
		return
	endif

	if len(w:amcMru) > 2
		if !empty(w:amcMruWin) && len(w:amcMruWin) > 2
			if index(w:amcMruWin, l:bn) < 2
				echo "mru remove: too close to start of mruWin, doing nothing"
				return
			endif
		endif

		" new #
		call amc#mru#back()
		call amc#mru#back()

		" new %
		call amc#mru#forward()

		" remove from mru
		let l:bi = index(w:amcMru, l:bn)
		if l:bi >= 0
			call remove(w:amcMru, l:bi)
		endif

		" remove from win
		let l:bi = index(w:amcMruWin, l:bn)
		if l:bi >= 0
			call remove(w:amcMruWin, l:bi)
		endif

		call amc#mru#prn("mru: removed", 0)
	else
		echo "mru remove: <2 other buffers, doing nothing"
	endif
endfunction

function amc#mru#winNew()
	call amc#mru#initWinVars()

	" optimistically clone from the old window; it will be cleared on update
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

