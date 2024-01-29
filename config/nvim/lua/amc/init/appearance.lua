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

-- nvim-tree clear
vim.cmd("highlight! link NvimTreeImageFile NONE")
vim.cmd("highlight! link NvimTreeSpecialFile NONE")
vim.cmd("highlight! link NvimTreeModifiedIcon NONE")

-- nvim-tree override
vim.cmd("highlight! link NvimTreeRootFolder NvimTreeOpenedHL")
vim.cmd("highlight! link NvimTreeSymLink Italic")
vim.cmd("highlight! link NvimTreeExecFile Bold")

