let g:amc#buf#SPECIAL = 1
let g:amc#buf#ORDINARY_HAS_FILE = 2
" care: this is what a special buf looks like when it is first created, with buftype etc. not set
let g:amc#buf#ORDINARY_NO_FILE = 3
let g:amc#buf#NO_NAME_NEW = 4
let g:amc#buf#NO_NAME_MODIFIED = 5

function! amc#buf#flavour(buf)
	let l:name = bufname(a:buf)

	if strlen(getbufvar(a:buf, "&buftype")) != 0
		return g:amc#buf#SPECIAL
	endif

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
	if amc#buf#flavour(bufnr("#")) == g:amc#buf#SPECIAL
		return
	endif

	b!#
endfunction

