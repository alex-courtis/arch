function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction


function! amc#colours()
	highlight default link TagbarHighlight CursorLine
endfunction


function! amc#goToWinWithBufType(bt)

	if &buftype == a:bt
		call amc#log("GTWWBT exiting early")
		return
	endif

	for l:wn in range(1, winnr("$"))
		if getbufvar(winbufnr(l:wn), "&buftype") == a:bt
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

