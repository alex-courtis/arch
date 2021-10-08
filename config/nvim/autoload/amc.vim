function! amc#log(msg)
	call system("echo \"" . a:msg . "\" >> /tmp/vim." . $USER . ".log")
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

function! amc#qfPost()
	call amc#win#goHome()
	cclose
	belowright cwindow

	let l:title = getqflist({"title" : 0}).title
	let l:size = getqflist({"size" : 0}).size
	let g:amc#grepping = l:size > 0 && match(l:title, ':\s*' . &grepprg . '\s*') >= 0

	if g:amc#grepping
		let l:pattern = substitute(l:title, ':\s*' . &grepprg . '\s*', "", "")
		let l:pattern = substitute(l:pattern, '-\S\+', "", "g")
		let l:pattern = substitute(l:pattern, '^\s*[''"]', "", "")
		let l:pattern = substitute(l:pattern, '["'']\s*$', "", "")
		let @/ = l:pattern
	endif
endfunction

