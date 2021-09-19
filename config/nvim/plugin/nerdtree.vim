" nerdtree
"
let NERDTreeMinimalUI=1

let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

set wildignore+=*.o,*.class
let NERDTreeRespectWildIgnore=1

autocmd StdinReadPre * let s:std_in=1

" Start NERDTree when Vim is started without any arguments or stdin.
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree when Vim starts with single directory argument and focus it.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
			\ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | execute 'NERDTreeFocus' | endif

autocmd BufEnter * call amc#nt#sync()
"
" nerdtree

