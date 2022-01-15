if !exists('g:amcLog')
	let g:amcLog = 0
endif

let s:first = 0
function! amc#log(msg)
	if !g:amcLog
		return
	endif
	if !s:first
		call system("echo ---------------- >> /tmp/vim." . $USER . ".log")
		let s:first = 1
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
endfunction


function! amc#updateTitleString()
	if &modifiable && &buflisted && strlen(&buftype) == 0 && filereadable(bufname())
		let &titlestring = system('printtermtitle') . ' %m'
	else
		let &titlestring = system('printtermtitle')
	endif
endfunction


function! amc#safeBufExplorer()
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


function! amc#vselFirstLine()
	try
		let l:zprev = @z
		normal! gv"zy
		return substitute(@z, "\n.*", "", "g")
	finally
		let @z = l:zprev
	endtry
endfunction

function! amc#updateAgPattern()
	let l:title = getqflist({"title" : 0}).title
	let l:size = getqflist({"size" : 0}).size
	let g:amc#aging = l:size > 0 && match(l:title, ':\s*' . &grepprg . '\s*') >= 0

	if g:amc#aging
		let l:pattern = substitute(l:title, ':\s*' . &grepprg . '\s*', "", "")
		let l:pattern = substitute(l:pattern, '-\S\+\s*', "", "g")
		if match(l:pattern, '^.\{-}[''"]') >= 0
			let l:pattern = substitute(l:pattern, '^.\{-}[''"]', "", "")
			let l:pattern = substitute(l:pattern, '["''].*$', "", "")
		else
			let l:pattern = substitute(l:pattern, '\s\+\S*$', "", "")
		endif
		let @/ = l:pattern
	endif
endfunction

function! amc#qfPost()
	call amc#win#goHome()
	cclose
	aboveleft cwindow
endfunction

function! amc#setPathCwd()
	let &path = getcwd() . "/**"
endfunction

