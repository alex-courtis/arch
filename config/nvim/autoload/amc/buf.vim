let g:amc#buf#SPECIAL = 1
let g:amc#buf#ORDINARY_HAS_FILE = 2
let g:amc#buf#ORDINARY_NO_FILE = 3
let g:amc#buf#NO_NAME_NEW = 4
let g:amc#buf#NO_NAME_MODIFIED = 5

" on creation these do not have &buftype set at BufEnter
let s:specialNames = [
			\ 'NvimTree',
			\ 'NERD_tree',
			\ '\[BufExplorer\]',
			\ '__Tagbar__',
			\ 'gitgutter://hunk-preview',
			\]

function amc#buf#flavour(buf)
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

function amc#buf#flavourName(flavour)
	if a:flavour == g:amc#buf#SPECIAL
		return "SPECIAL"
	elseif a:flavour == g:amc#buf#ORDINARY_HAS_FILE
		return "ORDINARY_HAS_FILE"
	elseif a:flavour == g:amc#buf#ORDINARY_NO_FILE
		return "ORDINARY_NO_FILE"
	elseif a:flavour == g:amc#buf#NO_NAME_NEW
		return "NO_NAME_NEW"
	elseif a:flavour == g:amc#buf#NO_NAME_MODIFIED
		return "NO_NAME_MODIFIED"
	else
		return "unknown"
	endif
endfunction

function amc#buf#safeHash()
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

function amc#buf#autoWrite()
	if amc#buf#flavour(bufnr()) == g:amc#buf#ORDINARY_HAS_FILE
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

