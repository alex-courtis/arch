if vim.fn.system("underlyingterm") == "linux" then
  return
end

vim.o.background = "dark"
vim.o.termguicolors = true

vim.cmd("colorscheme base16")

vim.cmd("highlight CursorLineNr cterm=bold gui=bold")

vim.cmd("highlight TrailingSpace ctermbg=9 guibg=red")

vim.cmd(string.format("highlight Search guibg=%s", vim.env.BASE09)) -- yellow -> orange
vim.cmd(string.format("highlight IncSearch guibg=%s", vim.env.BASE0A)) -- orange -> yellow

vim.cmd(string.format("highlight! link NvimTreeWindowPicker Cursor"))
