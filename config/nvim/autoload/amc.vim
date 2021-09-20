function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction

function! amc#colours()
	highlight default link TagbarHighlight CursorLine
endfunction

function! amc#goToWinWithBufType(bt)
	if &buftype == a:bt
		return
	endif

	for l:wn in range(1, winnr("$"))
		if getbufvar(winbufnr(l:wn), "&buftype") == a:bt
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

function! amc#closeOtherWin()

	let l:cwn = winnr()
	for l:wn in range(winnr("$"), 1, -1)
		if l:wn != l:cwn
			execute l:wn . " wincmd c"
		endif
	endfor
endfunction

function! amc#firstOrNext(bt)
	if &buftype != a:bt
		call amc#goToWinWithBufType(a:bt)
	else
		call amc#log("")
		for l:wn in range(winnr() + 1, winnr("$")) + range(1, winnr())
			if getbufvar(winbufnr(l:wn), "&buftype") == a:bt
				execute l:wn . " wincmd w"
				return
			endif
		endfor
	endif
endfunction

