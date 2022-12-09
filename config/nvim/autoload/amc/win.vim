function amc#win#goHome()
	lua require('amc/windows').go_home()
endfunction

let s:closeOrder = [
			\ g:amc#buf#QUICK_FIX,
			\ g:amc#buf#FUGITIVE,
			\ g:amc#buf#HELP,
			\ g:amc#buf#NERD_TREE,
			\ g:amc#buf#NVIM_TREE,
			\ g:amc#buf#TAGBAR,
			\ ]
function amc#win#closeInc()

	" close lowest if present
	let l:lsi = -1
	let l:lsw = -1
	for l:wn in range(1, winnr("$"))
		let l:special = amc#buf#special(winbufnr(l:wn))
		if l:special
			let l:i = index(s:closeOrder, l:special)
			if l:lsi == -1 || l:i < l:lsi
				let l:lsi = l:i
				let l:lsw = l:wn
			endif
		endif
	endfor
	if l:lsw != -1
		execute l:lsw . " wincmd c"
		return
	endif

	" close whatever is next
	let l:cwn = winnr()
	for l:wn in range(winnr("$"), 1, -1)
		if l:wn != l:cwn
			execute l:wn . " wincmd c"
			return
		endif
	endfor
endfunction

let s:wipeOnClosed = [
			\ g:amc#buf#MAN,
			\ ]
function amc#win#wipeOnClosed()
	let l:bn = winbufnr(expand('<amatch>'))
	if l:bn != -1
		if index(s:wipeOnClosed, amc#buf#special(l:bn)) != -1
			execute "bw" . l:bn
		endif
	endif
endfunction

function amc#win#smartFugitive()
	for l:wn in range(1, winnr("$"), 1)
		if getbufvar(winbufnr(l:wn), "&filetype") == 'fugitive'
			execute l:wn . " wincmd w"
			return
		endif
	endfor

	:G
endfunction
