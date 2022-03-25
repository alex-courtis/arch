let g:amc#buf#SPECIAL = 1
let g:amc#buf#ORDINARY_HAS_FILE = 2
let g:amc#buf#ORDINARY_NO_FILE = 3
let g:amc#buf#NO_NAME_NEW = 4
let g:amc#buf#NO_NAME_MODIFIED = 5
let g:amc#buf#MAN = 6
let g:amc#buf#SCRATCH = 7
let g:amc#buf#flavourNames = [
			\ "NO_FLAVOUR",
			\ "SPECIAL",
			\ "ORDINARY_HAS_FILE",
			\ "ORDINARY_NO_FILE",
			\ "NO_NAME_NEW",
			\ "NO_NAME_MODIFIED",
			\ "MAN",
			\ "SCRATCH",
			\]

let g:amc#buf#BUF_EXPLORER = 1
let g:amc#buf#FUGITIVE = 2
let g:amc#buf#GIT = 3
let g:amc#buf#HELP = 5
let g:amc#buf#NERD_TREE = 6
let g:amc#buf#NVIM_TREE = 7
let g:amc#buf#QUICK_FIX = 8
let g:amc#buf#TAGBAR = 9
let g:amc#buf#OTHER_SPECIAL = 10
let g:amc#buf#specialNames = [
			\ "NO_SPECIAL",
			\ "BUF_EXPLORER",
			\ "FUGITIVE",
			\ "GIT",
			\ "HELP",
			\ "NERD_TREE",
			\ "NVIM_TREE",
			\ "QUICK_FIX",
			\ "TAGBAR",
			\ "OTHER_SPECIAL",
			\]

" on creation some may not have &buftype set at BufEnter
let s:specialNames = [
			\ 'NERD_tree',
			\ '\[BufExplorer\]',
			\ '__Tagbar__',
			\ 'fugitive://',
			\]
let s:notSpecialNames = [
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
		if l:name =~# '^man://' || getbufvar(a:buf, "&filetype") == "man"
			return g:amc#buf#MAN
		elseif filereadable(l:name)
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

	if l:name =~# '\[BufExplorer\]'
		return g:amc#buf#BUF_EXPLORER
	elseif getbufvar(a:buf, "&filetype") =~# '^git'
		return g:amc#buf#GIT
	elseif getbufvar(a:buf, "&filetype") =~# '^fugitive' || l:name =~# '^fugitive://'
		return g:amc#buf#FUGITIVE
	elseif getbufvar(a:buf, "&buftype") == "help"
		return g:amc#buf#HELP
	elseif l:name =~# 'NERD_tree'
		return g:amc#buf#NERD_TREE
	elseif l:name =~# 'NvimTree'
		return g:amc#buf#NVIM_TREE
	elseif getbufvar(a:buf, "&buftype") == "quickfix"
		return g:amc#buf#QUICK_FIX
	elseif l:name =~# '__Tagbar__'
		return g:amc#buf#TAGBAR
	endif

	return g:amc#buf#OTHER_SPECIAL
endfunction

function amc#buf#isSpecial(buf)
	let l:name = bufname(a:buf)

	" do not match the list as l:name will be interpreted as a pattern
	for l:notSpecialName in s:notSpecialNames
		if match(l:name, l:notSpecialName) == 0
			return 0
		endif
	endfor

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

function amc#buf#safeHash()
	if amc#buf#isSpecial(bufnr("%"))
		return
	endif
	if bufnr("#") < 0
		return
	endif
	if amc#buf#isSpecial(bufnr("#"))
		return
	endif

	b!#
endfunction

function amc#buf#autoWrite()
	if !&readonly && amc#buf#flavour(bufnr("%")) == g:amc#buf#ORDINARY_HAS_FILE
		update
	endif
endfunction

" no name new buffers are not wiped when loading an existing buffer over them
function amc#buf#wipeAltNoNameNew()
	let l:bn = bufnr('%')
	let l:bna = bufnr('#')
	let l:bwna = bufwinnr(l:bna)
	if l:bna != -1 && l:bn != l:bna && l:bwna == -1
		if amc#buf#flavour(l:bna) == g:amc#buf#NO_NAME_NEW
			call amc#log#line("amc#buf#wipeAltNoNameNew wiping " . l:bna)
			execute "bw" . l:bna
		endif
	endif
endfunction

