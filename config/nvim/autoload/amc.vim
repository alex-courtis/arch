let s:firstLogLine = 0
function! amc#log(msg)
	if !g:amcLog
		return
	endif
	if !s:firstLogLine
		call system("echo ---------------- >> /tmp/vim." . $USER . ".log")
		let s:firstLogLine = 1
	endif
	call system("echo \'" . substitute(a:msg, "'", "'\"'\"\'", "g") . "\' >> /tmp/vim." . $USER . ".log")
endfunction


function! amc#sourceIfExists(file)
	if filereadable(expand(a:file))
		exe 'source' a:file
	endif
endfunction


function! amc#colours()
	highlight CursorLineNr cterm=NONE ctermfg=7
	highlight default link TagbarHighlight CursorLine
	highlight Search ctermfg=18 ctermbg=16
	highlight IncSearch ctermfg=18 ctermbg=3
endfunction


function! amc#updateTitleString()
	if &modifiable && &buflisted && strlen(&buftype) == 0 && filereadable(bufname())
		let &titlestring = system('printtermtitle') . ' %m'
	else
		let &titlestring = system('printtermtitle')
	endif
endfunction


function! amc#vselFirstLine()
	try
		let l:zprev = @z
		normal! gv"zy
		return substitute(@z, "\n.*", "", "g")
	finally
		let @z = l:zprev
	endtry
endfunction


function! amc#setPathCwd()
	let &path = getcwd() . "/**"
endfunction

