function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction

function! amc#colours()
	highlight default link TagbarHighlight CursorLine
endfunction

function! amc#goHome()
	call amc#goFirstWin("")
endfunction

function! amc#goHelp()
	call amc#goFirstWin("help")
endfunction

function! amc#goFirstWin(bt)
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

function! amc#goHomeOrNext()
	if &buftype != ""
		call amc#goHome()
		return
	endif

	for l:wn in range(winnr() + 1, winnr("$")) + range(1, winnr() - 1)
		if getbufvar(winbufnr(l:wn), "&buftype") == ""
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

