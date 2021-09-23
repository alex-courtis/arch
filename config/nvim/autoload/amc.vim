function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction


function! amc#colours()
	highlight default link TagbarHighlight CursorLine
endfunction


function! amc#delBuf()
	let l:cbn = bufnr()
	let l:cwn = winnr()

	" do not mess with unlisted or new buffers
	if !&buflisted || bufname() == ""
		return
	endif

	" go backward through windows in case one gets closed
	let l:nbn = 0
	for l:wn in range(winnr("$"), 1, -1)
		if winbufnr(l:wn) == l:cbn
			execute l:wn . " wincmd w"
			if l:nbn
				" switch to the new one we created earlier
				execute "b " . l:nbn
			elseif bufnr('#') != -1 && buflisted('#')
				" alternate is preferable
				b #
			else
				" previous is acceptable
				bp
				if bufnr() == l:cbn
					" no other buffers remain
					enew
					let l:nbn = bufnr()
				endif
			endif
		endif
	endfor

	execute l:cwn . " wincmd w"
	execute "bd! " . l:cbn
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

