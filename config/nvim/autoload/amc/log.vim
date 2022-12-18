function amc#log#line(msg)
	exec "lua require('amc.log').line('" . a:msg . "')"
endfunction

function amc#log#winBuf(msg)

	let l:bn = bufnr('%')
	let l:bna = bufnr('#')
	let l:bwn = bufwinnr(l:bn)
	let l:bwna = bufwinnr(l:bna)

	let l:flavour = amc#buf#flavour(l:bn)
	let l:desc = g:amc#buf#flavourNames[l:flavour]
	let l:flavourAlt = amc#buf#flavour(l:bna)
	let l:descAlt = g:amc#buf#flavourNames[l:flavourAlt]
	if l:flavour == g:amc#buf#SPECIAL
		let l:desc = g:amc#buf#specialNames[amc#buf#special(l:bn)]
	endif
	if l:flavourAlt == g:amc#buf#SPECIAL
		let l:descAlt = g:amc#buf#specialNames[amc#buf#special(l:bna)]
	endif

	let l:bt = getbufvar(l:bn, "&buftype")
	let l:bta = getbufvar(l:bna, "&buftype")
	let l:ft = getbufvar(l:bn, "&filetype")
	let l:fta = getbufvar(l:bna, "&filetype")

	let l:fmt = "%-12.12s %3s %4s %-17.17s %s b%-2d w%-2d %-8.8s %-8.8s \"%s\""
	call amc#log#line(printf(l:fmt, a:msg, "w" . winnr(), win_getid(), l:desc, "%%", l:bn, l:bwn, l:bt, l:ft, bufname("%")))
	if l:bna != -1
		call amc#log#line(printf(l:fmt, "", "", "", l:descAlt, "#", l:bna, l:bwna, l:bta, l:fta, bufname("#")))
	endif
endfunction

function amc#log#startEventLogging()
	" autocmd BufAdd      * call amc#log#winBuf("BufAdd")
	autocmd BufDelete   * call amc#log#winBuf("BufDelete")
	autocmd BufEnter    * call amc#log#winBuf("BufEnter")
	autocmd BufHidden   * call amc#log#winBuf("BufHidden")
	autocmd BufLeave    * call amc#log#winBuf("BufLeave")
	autocmd BufNew      * call amc#log#winBuf("BufNew")
	autocmd BufNewFile  * call amc#log#winBuf("BufNewFile")
	autocmd BufUnload   * call amc#log#winBuf("BufUnload")
	autocmd BufWinEnter * call amc#log#winBuf("BufWinEnter")
	autocmd BufWinLeave * call amc#log#winBuf("BufWinLeave")
	autocmd BufWipeout  * call amc#log#winBuf("BufWipeout")
	autocmd FileType    * call amc#log#winBuf("FileType")
	autocmd VimEnter    * call amc#log#winBuf("VimEnter")
	autocmd WinClosed   * call amc#log#winBuf("WinClosed")
	autocmd WinEnter    * call amc#log#winBuf("WinEnter")
	autocmd WinLeave    * call amc#log#winBuf("WinLeave")
	autocmd WinNew      * call amc#log#winBuf("WinNew")
endfunction

