function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction


function! amc#colours()
	highlight default link TagbarHighlight CursorLine
endfunction

" TODO # lingers on the deleted buffer
" TODO use bufexplorer's LRU instead of the fallback bn
function! amc#delBuf()
	" forcing is here for the case of a new buffer with unsaved changes

	let l:cbn = bufnr()
	let l:cwn = winnr()

	call amc#log("delBuf ")
	call amc#log(" cbn=" . l:cbn . "\tcwn=" . l:cwn)

	if !&buflisted
		echo "amc#delBuf ignoring !&buflisted"
		return
	endif

	if &buftype != ""
		echo "amc#delBuf ignoring &buftype=" . &buftype
		return
	endif

	for l:wn in range(1, winnr("$"))
		if l:wn != l:cwn && winbufnr(l:wn) == l:cbn
			echo "amc#delBuf ignoring buffer open in multiple windows"
			return
		endif
	endfor

	let l:abn = bufnr("#")
	let l:abt = getbufvar("#", "&buftype")
	call amc#log(" abn=" . l:abn . "\tabt=" . l:abt)

	if l:abn != l:cbn && l:abn != -1 && buflisted(l:abn) && l:abt == ""
		call amc#log(" b! " . l:abn)
		execute "b! " . l:abn
	else
		call amc#log(" bn!")
		execute "bn!"
	endif

	if bufnr() == l:cbn
		call amc#log(" enew!")
		execute "enew!"
	endif

	if getbufvar(l:cbn, "&buflisted")
		call amc#log(" bd! " . l:cbn)
		execute "bd! " . l:cbn
	endif

	call amc#log("\n")
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

