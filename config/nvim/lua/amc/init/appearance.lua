vim.o.background = "dark"

vim.cmd("highlight CursorLineNr cterm=bold gui=bold")

-- nvim-tree clear
vim.cmd("highlight! link NvimTreeImageFile NONE")
vim.cmd("highlight! link NvimTreeSpecialFile NONE")
vim.cmd("highlight! link NvimTreeModifiedIcon NONE")
vim.cmd("highlight! link NvimTreeExecFile NONE")
vim.cmd("highlight! link NvimTreeRootFolder NONE")

-- nvim-tree override
vim.cmd("highlight! link NvimTreeNormal Comment")
vim.cmd("highlight! link NvimTreeSymLink Italic")

if not vim.env.TERM:match("^linux") then
  vim.o.cursorline = true
end

vim.cmd("colorscheme base16")

vim.cmd("highlight TrailingSpace ctermbg=Red guibg=#" .. vim.env.BASE16_red)

vim.cmd("highlight Search guibg=#" .. vim.env.BASE16_orange) -- default yellow
vim.cmd("highlight IncSearch guibg=#" .. vim.env.BASE16_yellow) -- default orange

-- nvim-tree override
vim.cmd("highlight NvimTreeOpenedHL guifg=#" .. vim.env.BASE16_default_foreground)

