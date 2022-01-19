let g:amc#buf#SPECIAL = 1
let g:amc#buf#ORDINARY_HAS_FILE = 2
let g:amc#buf#ORDINARY_NO_FILE = 3
let g:amc#buf#NO_NAME_NEW = 4
let g:amc#buf#NO_NAME_MODIFIED = 5

" on creation these do not have &buftype set at BufEnter
let s:specialNames = [
			\ 'NERD_tree',
			\ '\[BufExplorer\]',
			\ '__Tagbar__',
			\ 'gitgutter://hunk-preview',
			\]

function! amc#buf#flavour(buf)
	let l:name = bufname(a:buf)

	if strlen(getbufvar(a:buf, "&buftype")) != 0
		return g:amc#buf#SPECIAL
	endif

	" do not match the list as l:name will be interpreted as a pattern
	for l:specialName in s:specialNames
		if match(l:name, l:specialName) == 0
			return g:amc#buf#SPECIAL
		endif
	endfor

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

function! amc#buf#safeHash()
	if amc#buf#flavour(bufnr()) == g:amc#buf#SPECIAL
		return
	endif
	if bufnr("#") < 0
		return
	endif
	if amc#buf#flavour(bufnr("#")) == g:amc#buf#SPECIAL
		return
	endif

	b!#
endfunction

function! amc#buf#safeBufExplorer()
	call amc#win#goBufName("[BufExplorer]")
	if bufname() == "[BufExplorer]"
		return
	endif

	call amc#win#goHome()

	let l:flavour = amc#buf#flavour(bufnr())
	if l:flavour == g:amc#buf#ORDINARY_HAS_FILE || l:flavour == g:amc#buf#ORDINARY_NO_FILE
		BufExplorer
		return
	endif
endfunction

function! amc#buf#autoWrite()
	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
		update
	endif
endfunction

