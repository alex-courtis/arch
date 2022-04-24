function amc#win#goHome()

	" topleftest nonspecial
	let [ l:lowestRow, l:lowestCol, l:topLeftWn ] = [ 0, 0, 0 ]
	for l:wn in range(winnr("$"), 1, -1)
		if !getwinvar(l:wn, "amcSpecial")
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
	if get(w:, 'amcSpecial', 0)
		call amc#win#goHome()
		return
	endif

	" search up from this window then start at 0
	for l:wn in range(winnr() + 1, winnr("$")) + range(1, winnr() - 1)
		if !getwinvar(l:wn, "amcSpecial")
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

function amc#win#openBufExplorer()
	if get(w:, 'amcSpecial', 0)
		call amc#win#goHome()
	endif

	BufExplorer
endfunction

function amc#win#goBufName(bn)
	if bufname() == a:bn
		return
	endif

	for l:wn in range(1, winnr("$"))
		if bufname(winbufnr(l:wn)) == a:bn
			execute l:wn . " wincmd w"
			return
		endif
	endfor
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
		let l:amcSpecial = getwinvar(l:wn, "amcSpecial")
		if l:amcSpecial
			let l:i = index(s:closeOrder, l:amcSpecial)
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

" one shot mark the window as special via w:amcSpecial
" except OTHER_SPECIAL will be overwritten by a known special
" event ordering is inconsistent, hence this is called for many events
function amc#win#markSpecial()
	let l:bn = bufnr("%")
	if l:bn == -1
		return
	endif

	let l:curSpecial = get(w:, 'amcSpecial', 0)
	if l:curSpecial && l:curSpecial != g:amc#buf#OTHER_SPECIAL
		return
	endif

	let l:special = amc#buf#special(l:bn)
	if !l:special || l:special == g:amc#buf#BUF_EXPLORER
		return
	endif

	let w:amcSpecial = l:special
	call amc#log#line("amc#win#markSpecial marking " . winnr() . " " . g:amc#buf#specialNames[w:amcSpecial])
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

