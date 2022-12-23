let g:amc#buf#SPECIAL = 1
let g:amc#buf#ORDINARY_HAS_FILE = 2
let g:amc#buf#ORDINARY_NO_FILE = 3
let g:amc#buf#NO_NAME_NEW = 4
let g:amc#buf#NO_NAME_MODIFIED = 5
let g:amc#buf#SCRATCH = 6
let g:amc#buf#flavourNames = [
			\ "NO_FLAVOUR",
			\ "SPECIAL",
			\ "ORDINARY_HAS_FILE",
			\ "ORDINARY_NO_FILE",
			\ "NO_NAME_NEW",
			\ "NO_NAME_MODIFIED",
			\ "SCRATCH",
			\]

let g:amc#buf#FUGITIVE = 1
let g:amc#buf#GIT = 2
let g:amc#buf#HELP = 3
let g:amc#buf#NVIM_TREE = 4
let g:amc#buf#QUICK_FIX = 5
let g:amc#buf#MAN = 6
let g:amc#buf#OTHER_SPECIAL = 7
let g:amc#buf#specialNames = [
			\ "NO_SPECIAL",
			\ "FUGITIVE",
			\ "GIT",
			\ "HELP",
			\ "NVIM_TREE",
			\ "QUICK_FIX",
			\ "MAN",
			\ "OTHER_SPECIAL",
			\]

" on creation some may not have &buftype set at BufEnter
let s:specialNames = [
			\ 'fugitive://',
			\ 'man://',
			\]

function amc#buf#flavour(buf)
	if amc#buf#isSpecial(a:buf)
		return g:amc#buf#SPECIAL
	endif

	if amc#buf#isScratch(a:buf)
		return g:amc#buf#SCRATCH
	endif

	let l:name = bufname(a:buf)
	if strlen(l:name) == 0
		if getbufvar(a:buf, "&modified")
			return g:amc#buf#NO_NAME_MODIFIED
		else
			return g:amc#buf#NO_NAME_NEW
		endif
	else
		if filereadable(l:name)
			return g:amc#buf#ORDINARY_HAS_FILE
		else
			return g:amc#buf#ORDINARY_NO_FILE
		endif
	endif
endfunction

function amc#buf#isScratch(buf)
	return strlen(bufname(a:buf)) == 0 &&
				\ getbufvar(a:buf, "&buftype") == "nofile" &&
				\ getbufvar(a:buf, "&bufhidden") == "hide" &&
				\ !getbufvar(a:buf, "&swapfile")
endfunction

function amc#buf#special(buf)
	if !amc#buf#isSpecial(a:buf)
		return 0
	endif

	let l:name = bufname(a:buf)

	if getbufvar(a:buf, "&filetype") =~# '^git'
		return g:amc#buf#GIT
	elseif getbufvar(a:buf, "&filetype") =~# '^fugitive' || l:name =~# '^fugitive://'
		return g:amc#buf#FUGITIVE
	elseif getbufvar(a:buf, "&filetype") =~# '^man' || l:name =~# '^man://'
		return g:amc#buf#MAN
	elseif getbufvar(a:buf, "&buftype") == "help"
		return g:amc#buf#HELP
	elseif l:name =~# 'NvimTree'
		return g:amc#buf#NVIM_TREE
	elseif getbufvar(a:buf, "&buftype") == "quickfix"
		return g:amc#buf#QUICK_FIX
	endif

	return g:amc#buf#OTHER_SPECIAL
endfunction

function amc#buf#isSpecial(buf)
	let l:name = bufname(a:buf)

	if amc#buf#isScratch(a:buf)
		return 0
	endif

	if strlen(getbufvar(a:buf, "&buftype")) != 0
		return g:amc#buf#SPECIAL
	endif

	" do not match the list as l:name will be interpreted as a pattern
	for l:specialName in s:specialNames
		if match(l:name, l:specialName) == 0
			return g:amc#buf#SPECIAL
		endif
	endfor

	return 0
endfunction

