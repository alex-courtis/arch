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

function! amc#win#updateMruEnter()
	if !exists('w:amcMru')
		let w:amcMru = []
	endif
	if !exists('w:amcMruPointer')
		let w:amcMruPointer = 0
	endif

	let l:wn = winnr()
	let l:bn = bufnr()
	let l:bname = bufname()

	if &buftype != "" || !&buflisted || (l:bname != "" && !filereadable(l:bname))
		return
	endif

	let l:bi = index(w:amcMru, l:bn)
	if (l:bi >= 0)
		call remove(w:amcMru, l:bi)
	endif
	call add(w:amcMru, l:bn)
	call amc#log("w" . l:wn . " " . string(w:amcMru))
endfunction

function! amc#win#updateMruLeave()
	" TODO maybe clean remove if the buffer has become unlisted etc.
endfunction

function! amc#win#backMru()
	call amc#log("backMru")
endfunction

function! amc#win#forwardMru()
	call amc#log("forwardMru")
endfunction

