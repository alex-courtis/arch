if vim.env.TERM == "linux" then
  return
end

vim.o.background = "dark"
vim.o.termguicolors = true

vim.cmd("colorscheme base16")

-- changing MsgArea clears messages: https://github.com/neovim/neovim/issues/17832
vim.cmd("highlight clear MsgArea")

vim.cmd("highlight CursorLineNr cterm=bold gui=bold")

vim.cmd("highlight TrailingSpace cterm=undercurl gui=undercurl guisp=#" .. vim.env.BASE16_red)

vim.cmd("highlight Search guibg=#" .. vim.env.BASE16_orange) -- default yellow
vim.cmd("highlight IncSearch guibg=#" .. vim.env.BASE16_yellow) -- default orange

-- nvim-tree
vim.cmd("highlight! link NvimTreeExecFile Italic")
vim.cmd("highlight! link NvimTreeOpenedFile SpecialChar")
vim.cmd("highlight! link NvimTreeSymLink Comment")
