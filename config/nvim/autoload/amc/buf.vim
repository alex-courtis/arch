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

function! amc#buf#del()
	" forcing is here for the case of a new buffer with unsaved changes
	call amc#log("amc#buf#del ")
	let l:cwn = winnr()

	let l:cbn = bufnr()
	let l:cbt = getbufvar(l:cbn, "&buftype")
	let l:cbm = getbufvar(l:cbn, "&modified")
	call amc#log(" cur: " . l:cbn . " '" . bufname(l:cbn) . "' buftype='" . l:cbt . "' buflisted=" . buflisted(l:cbn) . " modified=" . l:cbm)

	let l:abn = bufnr("#")
	let l:abt = getbufvar("#", "&buftype")
	let l:abm = getbufvar("#", "&modified")
	call amc#log(" alt: " . l:abn . " '" . bufname(l:abn) . "' buftype='" . l:abt . "' buflisted=" . buflisted(l:abn) . " modified=" . l:abm)

	if !&buflisted || &buftype != ""
		echo "amc#buf#del ignoring " . l:cbn . " '" . bufname(l:cbn) . "' buftype='" . l:cbt . "' buflisted=" . buflisted(l:cbn)
		return
	endif

	for l:wn in range(1, winnr("$"))
		if l:wn != l:cwn && winbufnr(l:wn) == l:cbn
			echo "amc#buf#del ignoring " . l:cbn . " '" . bufname(l:cbn) . "' open in multiple windows"
			return
		endif
	endfor

	if l:abn != l:cbn && l:abn != -1 && buflisted(l:abn) && l:abt == ""
		call amc#log(" b! #")
		execute "b! #"
		call amc#log(" -> " . bufnr() . " '" . bufname() . "' buftype='" . &buftype . "' buflisted=" . &buflisted)
	else
		call amc#log(" bn!")
		execute "bn!"
		call amc#log(" -> " . bufnr() . " '" . bufname() . "' buftype='" . &buftype . "' buflisted=" . &buflisted)

		if !&buflisted || &buftype != ""
			call amc#log(" b! " . l:cbn)
			execute "b!" . l:cbn
			call amc#log(" -> " . bufnr() . " '" . bufname() . "' buftype='" . &buftype . "' buflisted=" . &buflisted)
		endif
	endif

	if bufnr() == l:cbn
		call amc#log(" enew!")
		execute "enew!"
		call amc#log(" -> " . bufnr() . " '" . bufname() . "' buftype='" . &buftype . "' buflisted=" . &buflisted)
	endif

	if getbufvar(l:cbn, "&buflisted")
		" TODO this sometimes deletes the new and sends us to a bad place e.g. quickfix
		call amc#log(" bd! " . l:cbn . " " . bufname(l:cbn))
		execute "bd! " . l:cbn
		call amc#log(" -> " . bufnr() . " '" . bufname() . "' buftype='" . &buftype . "' buflisted=" . &buflisted)
	endif

	call amc#log("")
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

