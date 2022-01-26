function! amc#win#goHome()
	if &buftype == ""
		return
	endif

	" previous
	let l:pwn = winnr('#')
	if l:pwn && getbufvar(winbufnr(l:pwn), "&buftype") == ""
		execute l:pwn . " wincmd w"
		return
	endif

	" first available
	for l:wn in range(1, winnr("$"))
		if getbufvar(winbufnr(l:wn), "&buftype") == ""
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

function! amc#win#winForFileType(type)
	for l:wn in range(1, winnr("$"))
		let l:bnum = winbufnr(l:wn)
		let l:btype = getbufvar(l:bnum, "&filetype")
		if match(l:btype, a:type) != -1
			return l:wn
		endif
	endfor
	return 0
endfunction

function! amc#win#winForBufType(type)
	for l:wn in range(1, winnr("$"))
		let l:bnum = winbufnr(l:wn)
		let l:btype = getbufvar(l:bnum, "&buftype")
		if match(l:btype, a:type) != -1
			return l:wn
		endif
	endfor
	return 0
endfunction

function! amc#win#winForBufName(name)
	for l:wn in range(1, winnr("$"))
		let l:bnum = winbufnr(l:wn)
		let l:bname = bufname(l:bnum)
		if match(l:bname, a:name) != -1
			return l:wn
		endif
	endfor
	return 0
endfunction

function! amc#win#closeInc()
	let l:wn = amc#win#winForBufName("gitgutter://hunk-preview")
	if l:wn
		execute l:wn . " wincmd c"
		return
	endif

	let l:wn = amc#win#winForBufType("quickfix")
	if l:wn
		execute l:wn . " wincmd c"
		return
	endif

	let l:wn = amc#win#winForFileType("fugitive")
	if l:wn
		execute l:wn . " wincmd c"
		return
	endif

	let l:wn = amc#win#winForBufName("NvimTree")
	if l:wn
		execute l:wn . " wincmd c"
		return
	endif

	let l:wn = amc#win#winForBufName("NERD_tree_")
	if l:wn
		execute l:wn . " wincmd c"
		return
	endif

	let l:wn = amc#win#winForBufName("__Tagbar__")
	if l:wn
		execute l:wn . " wincmd c"
		return
	endif

	let l:wn = amc#win#winForBufType("help")
	if l:wn
		execute l:wn . " wincmd c"
		return
	endif

	let l:cwn = winnr()
	for l:wn in range(winnr("$"), 1, -1)
		if l:wn != l:cwn
			execute l:wn . " wincmd c"
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

function! amc#win#openFocusGitPreview()
	if gitgutter#hunk#is_preview_window_open()
		call amc#win#goBufName('gitgutter://hunk-preview')
	else
		GitGutterPreviewHunk
	endif
endfunction

function! amc#win#updateSpecial()
	let w:amcWasSpecial = bufnr("%") != -1 && amc#buf#flavour("%") == g:amc#buf#SPECIAL
	let w:amcWasFugitive = &filetype == "fugitive"
endfunction

" nvimtree handles this itself with a lot of thrashing; this short-circuits that
function! amc#win#moveFromSpecial()
	if !exists('w:amcWasSpecial') || !w:amcWasSpecial
		return
	endif

	let l:bn = bufnr("%")
	let l:abn = bufnr("#")
	if l:bn >= 0 && amc#buf#flavour("%") != g:amc#buf#SPECIAL && bufname("#") != "[BufExplorer]"
		if exists('w:amcWasFugitive') && w:amcWasFugitive
			" buffer is unusable until the window is closed
			wincmd c
		elseif l:abn >= 0
			" expected situation
			b#
		else
			" some specials like quickfix wipe themselves after leaving
			wincmd c
		endif
		call amc#win#goHome()
		exec "b" . l:bn
	endif
endfunction

