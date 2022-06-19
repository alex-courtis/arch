function amc#win#goHome()
	if !amc#buf#isSpecial(bufnr())
		return
	endif

	" topleftest nonspecial
	let [ l:lowestRow, l:lowestCol, l:topLeftWn ] = [ 0, 0, 0 ]
	for l:wn in range(winnr("$"), 1, -1)
		if !amc#buf#isSpecial(winbufnr(l:wn))
			let [ l:row, l:col ] = win_screenpos(l:wn)
			if (!l:lowestRow || !l:lowestCol) ||
						\ l:row == l:lowestRow && l:col < l:lowestCol ||
						\ l:row < l:lowestRow && l:col == l:lowestCol
				let [ l:lowestRow, l:lowesCol, l:topLeftWn ] = [ l:row, l:col, l:wn ]
			endif
		endif
	endfor
	if l:topLeftWn
		execute l:topLeftWn . " wincmd w"
		return
	endif

	" nuke the world and start over
	call amc#log#line("amc#win#goHome nuking")
	echom "amc#win#goHome nuking"
	new
	call amc#win#closeAll()
endfunction

function amc#win#goHomeOrNext()
	if amc#buf#isSpecial(bufnr())
		call amc#win#goHome()
		return
	endif

	" search up from this window then start at 0
	for l:wn in range(winnr() + 1, winnr("$")) + range(1, winnr() - 1)
		if !amc#buf#isSpecial(winbufnr(l:wn))
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

function amc#win#openBufExplorer()
	call amc#win#goHome()

	BufExplorer
endfunction

let s:closeOrder = [
			\ g:amc#buf#QUICK_FIX,
			\ g:amc#buf#FUGITIVE,
			\ g:amc#buf#HELP,
			\ g:amc#buf#NERD_TREE,
			\ g:amc#buf#NVIM_TREE,
			\ g:amc#buf#TAGBAR,
			\ ]
function amc#win#closeInc()

	" close lowest if present
	let l:lsi = -1
	let l:lsw = -1
	for l:wn in range(1, winnr("$"))
		let l:special = amc#buf#special(winbufnr(l:wn))
		if l:special
			let l:i = index(s:closeOrder, l:special)
			if l:lsi == -1 || l:i < l:lsi
				let l:lsi = l:i
				let l:lsw = l:wn
			endif
		endif
	endfor
	if l:lsw != -1
		execute l:lsw . " wincmd c"
		return
	endif

	" close whatever is next
	let l:cwn = winnr()
	for l:wn in range(winnr("$"), 1, -1)
		if l:wn != l:cwn
			execute l:wn . " wincmd c"
			return
		endif
	endfor
endfunction

function amc#win#closeAll()
	let l:cwn = winnr()
	for l:wn in range(winnr("$"), 1, -1)
		if l:wn != l:cwn
			execute l:wn . " wincmd c"
		endif
	endfor
endfunction

let s:wipeOnClosed = [
			\ g:amc#buf#MAN,
			\ ]
function amc#win#wipeOnClosed()
	let l:bn = winbufnr(expand('<amatch>'))
	if l:bn != -1
		if index(s:wipeOnClosed, amc#buf#special(l:bn)) != -1
			execute "bw" . l:bn
		endif
	endif
endfunction

