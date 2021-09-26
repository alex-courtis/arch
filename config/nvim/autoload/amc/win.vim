function! amc#win#goHome()
	call amc#win#goBufType("")
endfunction

function! amc#win#goHelp()
	call amc#win#goBufType("help")
endfunction

function! amc#win#goBufType(bt)
	if &buftype == a:bt
		return
	endif

	" previous if buf type
	let l:pwn = winnr('#')
	if l:pwn && getbufvar(winbufnr(l:pwn), "&buftype") == a:bt
		execute l:pwn . " wincmd w"
		return
	endif

	" first available
	for l:wn in range(1, winnr("$"))
		if getbufvar(winbufnr(l:wn), "&buftype") == a:bt
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

function! amc#win#goBufName(bn)
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

function! amc#win#closeAll()
	let l:cwn = winnr()

	for l:wn in range(winnr("$"), 1, -1)
		if l:wn != l:cwn
			execute l:wn . " wincmd c"
		endif
	endfor
endfunction

function! amc#win#goHomeOrNext()
	if &buftype != ""
		call amc#win#goHome()
		return
	endif

	" search up from this window then start at 0
	for l:wn in range(winnr() + 1, winnr("$")) + range(1, winnr() - 1)
		if getbufvar(winbufnr(l:wn), "&buftype") == ""
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

