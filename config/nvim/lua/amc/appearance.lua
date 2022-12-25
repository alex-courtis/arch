local mini_base16 = require("mini.base16")

local M = {}

if vim.fn.system("underlyingterm") == "linux" then
  return
end

mini_base16.setup({
  use_cterm = true,
  palette = {
    base00 = vim.env.BASE00,
    base01 = vim.env.BASE01,
    base02 = vim.env.BASE02,
    base03 = vim.env.BASE03,
    base04 = vim.env.BASE04,
    base05 = vim.env.BASE05,
    base06 = vim.env.BASE06,
    base07 = vim.env.BASE07,
    base08 = vim.env.BASE08,
    base09 = vim.env.BASE09,
    base0A = vim.env.BASE0A,
    base0B = vim.env.BASE0B,
    base0C = vim.env.BASE0C,
    base0D = vim.env.BASE0D,
    base0E = vim.env.BASE0E,
    base0F = vim.env.BASE0F,
  },
})

-- api doesn't allow setting individual attributes

vim.cmd("highlight CursorLineNr cterm=bold")

vim.cmd("highlight TrailingSpace ctermbg=9 guibg=red")

vim.cmd(string.format("highlight Search guibg=%s", vim.env.BASE09)) -- yellow -> orange
vim.cmd(string.format("highlight IncSearch guibg=%s", vim.env.BASE0A)) -- orange -> yellow

vim.cmd(string.format("highlight! link NvimTreeWindowPicker Cursor"))

return M
