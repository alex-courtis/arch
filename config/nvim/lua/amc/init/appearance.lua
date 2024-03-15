vim.o.background = "dark"

-- changing MsgArea clears messages: https://github.com/neovim/neovim/issues/17832
vim.cmd("highlight clear MsgArea")

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

-- halt when no cterm available
if tonumber(vim.o.t_Co) < 16 or vim.env.TERM == "linux" then
  return
end

-- linux term does not do this gracefully
vim.o.cursorline = true

-- halt when no gui available
if tonumber(vim.o.t_Co) < 256 then
  return
end

-- only when explicitly advertised
if vim.env.COLORTERM then
  vim.o.termguicolors = true
end

vim.cmd("colorscheme base16")

vim.cmd("highlight TrailingSpace cterm=undercurl gui=undercurl guisp=#" .. vim.env.BASE16_red)

vim.cmd("highlight Search guibg=#" .. vim.env.BASE16_orange) -- default yellow
vim.cmd("highlight IncSearch guibg=#" .. vim.env.BASE16_yellow) -- default orange

-- nvim-tree override
vim.cmd("highlight NvimTreeOpenedHL guifg=#" .. vim.env.BASE16_default_foreground)

