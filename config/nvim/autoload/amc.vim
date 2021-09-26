function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim.amc.log")
endfunction


function! amc#colours()
	highlight default link TagbarHighlight CursorLine
endfunction


function! amc#safeBufExplorer()
	call amc#win#goBufName("[BufExplorer]")
	if bufname() == "[BufExplorer]"
		return
	endif

	call amc#win#goHome()

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


function! amc#vselFirstLine()
	try
		let l:zprev = @z
		normal! gv"zy
		return substitute(@z, "\n.*", "", "g")
	finally
		let @z = l:zprev
	endtry
endfunction

