let s:firstLogLine = 1
function! amc#log#_line(msg)
	if s:firstLogLine
		call system("echo ---------------- >> /tmp/vim." . $USER . ".log")
		let s:firstLogLine = 0
	endif
	call system(printf("echo \'%s\' >> /tmp/vim.%s.log", substitute(a:msg, "'", "'\\\\''", "g"), $USER))
endfunction

function amc#log#line(msg)
	if g:amcLog
		call amc#log#_line(a:msg)
	endif
endfunction

function amc#log#winBuf(msg)
	let l:flavour = amc#buf#flavour(bufnr())
	let l:flavourName = amc#buf#flavourName(l:flavour)
	let l:flavourAlt = amc#buf#flavour(bufnr('#'))
	let l:flavourAltName = amc#buf#flavourName(l:flavourAlt)

	let l:bn = bufnr('%')
	let l:bna = bufnr('#')
	let l:bwn = bufwinnr(l:bn)
	let l:bwna = bufwinnr(l:bna)
	call amc#log#_line(printf("%s w%d %% b%d(w%2d) %-17.17s '%s'", a:msg, winnr(), l:bn, l:bwn, l:flavourName, bufname()))
	if l:bna != -1
		call amc#log#_line(printf("%s    # b%d(w%2d) %-17.17s '%s'", a:msg, l:bna, l:bwna, l:flavourAltName, bufname('#')))
	endif
endfunction

function amc#log#startEventLogging()
	autocmd BufAdd      * call amc#log#winBuf("BufAdd     ")
	autocmd BufDelete   * call amc#log#winBuf("BufDelete  ")
	autocmd BufEnter    * call amc#log#winBuf("BufEnter   ")
	autocmd BufHidden   * call amc#log#winBuf("BufHidden  ")
	autocmd BufLeave    * call amc#log#winBuf("BufLeave   ")
	autocmd BufNew      * call amc#log#winBuf("BufNew     ")
	autocmd BufNewFile  * call amc#log#winBuf("BufNewFile ")
	autocmd BufUnload   * call amc#log#winBuf("BufUnload  ")
	autocmd BufWinEnter * call amc#log#winBuf("BufWinEnter")
	autocmd BufWinLeave * call amc#log#winBuf("BufWinLeave")
	autocmd BufWipeout  * call amc#log#winBuf("BufWipeout ")
	autocmd FileType    * call amc#log#winBuf("FileType   ")
	autocmd VimEnter    * call amc#log#winBuf("VimEnter   ")
	autocmd WinClosed   * call amc#log#winBuf("WinClosed  ")
	autocmd WinEnter    * call amc#log#winBuf("WinEnter   ")
	autocmd WinLeave    * call amc#log#winBuf("WinLeave   ")
	autocmd WinNew      * call amc#log#winBuf("WinNew     ")
endfunction

