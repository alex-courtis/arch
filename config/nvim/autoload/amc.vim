function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction


function! amc#colours()
	highlight default link TagbarHighlight CursorLine
endfunction

function! amc#delBuf()
	" forcing is here for the case of a new buffer with unsaved changes
	call amc#log("delBuf ")
	let l:cwn = winnr()

	let l:cbn = bufnr()
	let l:cbt = getbufvar(l:cbn, "&buftype")
	let l:cbm = getbufvar(l:cbn, "&modified")
	call amc#log(" cur: " . l:cbn . " '" . bufname(l:cbn) . "' buftype='" . l:cbt . "' buflisted=" . buflisted(l:cbn) . " modified=" . l:cbm)

	let l:abn = bufnr("#")
	let l:abt = getbufvar("#", "&buftype")
	let l:abm = getbufvar("#", "&modified")
	call amc#log(" alt: " . l:abn . " '" . bufname(l:abn) . "' buftype='" . l:abt . "' buflisted=" . buflisted(l:abn) . " modified=" . l:abm)

	if !&buflisted || &buftype != ""
		echo "amc#delBuf ignoring " . l:cbn . " '" . bufname(l:cbn) . "' buftype='" . l:cbt . "' buflisted=" . buflisted(l:cbn)
		return
	endif

	for l:wn in range(1, winnr("$"))
		if l:wn != l:cwn && winbufnr(l:wn) == l:cbn
			echo "amc#delBuf ignoring " . l:cbn . " '" . bufname(l:cbn) . "' open in multiple windows"
			return
		endif
	endfor

	if l:abn != l:cbn && l:abn != -1 && buflisted(l:abn) && l:abt == ""
		call amc#log(" b! #")
		execute "b! #"
		call amc#log(" -> " . bufnr() . " '" . bufname() . "'")
	else
		call amc#log(" bn!")
		execute "bn!"
		call amc#log(" -> " . bufnr() . " '" . bufname() . "'")
	endif

	if bufnr() == l:cbn
		call amc#log(" enew!")
		execute "enew!"
		call amc#log(" -> " . bufnr() . " '" . bufname() . "'")
	endif

	if getbufvar(l:cbn, "&buflisted")
		call amc#log(" bd! " . l:cbn . " " . bufname(l:cbn))
		execute "bd! " . l:cbn
		call amc#log(" -> " . bufnr() . " '" . bufname() . "'")
	endif

	call amc#log("")
endfunction


function! amc#safeBHash()
	let l:abn = bufnr("#")
	if l:abn == -1 || getbufvar(l:abn, "&buftype") != "" || !buflisted(l:abn)
		return
	endif

	if bufname() == "" && &modified
		return
	endif

	b #
endfunction


function! amc#safeBufExplorer()
	call amc#goBufName("[BufExplorer]")
	if bufname() == "[BufExplorer]"
		return
	endif

	call amc#goHome()

	if bufname() == "" && &modified
		return
	endif

	for l:bn in range(1, bufnr("$"))
		if getbufvar(l:bn, "&buftype") == "" && buflisted(l:bn) && bufname(l:bn) != ""
			BufExplorer
			return
		endif
	endfor
endfunction


function! amc#goHome()
	call amc#goBufType("")
endfunction

function! amc#goHelp()
	call amc#goBufType("help")
endfunction

function! amc#goBufType(bt)
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

function! amc#goBufName(bn)
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

function! amc#closeAll()
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

	" search up from this window then start at 0
	for l:wn in range(winnr() + 1, winnr("$")) + range(1, winnr() - 1)
		if getbufvar(winbufnr(l:wn), "&buftype") == ""
			execute l:wn . " wincmd w"
			return
		endif
	endfor
endfunction

