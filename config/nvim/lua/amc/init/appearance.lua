if vim.fn.system("underlyingterm") == "linux" then
  return
end

vim.o.background = "dark"
vim.o.termguicolors = true

vim.cmd("colorscheme base16")

vim.cmd("highlight CursorLineNr cterm=bold gui=bold")

vim.cmd("highlight TrailingSpace ctermbg=9 guibg=red")

vim.cmd("highlight Search guibg=" .. vim.env.BASE16_ORANGE) -- default yellow
vim.cmd("highlight IncSearch guibg=" .. vim.env.BASE16_YELLOW) -- default orange

-- nvim-tree
vim.cmd("highlight! link NvimTreeWindowPicker lualine_a_insert")
vim.cmd("highlight NvimTreeGitDirty ctermfg=magenta guifg=" .. vim.env.BASE16_MAGENTA)
vim.cmd("highlight NvimTreeGitDeleted ctermfg=red guifg=" .. vim.env.BASE16_RED)
vim.cmd("highlight NvimTreeGitStaged ctermfg=yellow guifg=" .. vim.env.BASE16_ORANGE)
vim.cmd("highlight NvimTreeGitMerge	ctermfg=blue guifg=" .. vim.env.BASE16_BLUE)
vim.cmd("highlight NvimTreeGitNew ctermfg=green guifg=" .. vim.env.BASE16_GREEN)
vim.cmd("highlight NvimTreeModifiedFile ctermfg=magenta guifg=" .. vim.env.BASE16_MAGENTA)

vim.cmd("highlight! link NvimTreeNormal Comment")
vim.cmd("highlight! link NvimTreeOpenedFile DiagnosticHint")

vim.cmd("highlight! link NvimTreeExecFile NvimTreeNormal")
vim.cmd("highlight! link NvimTreeSymLink NvimTreeNormal")

-- override mini.base16
vim.cmd("highlight DiagnosticError ctermfg=red guifg=" .. vim.env.BASE16_RED)
vim.cmd("highlight DiagnosticWarn ctermfg=yellow guifg=" .. vim.env.BASE16_YELLOW)
vim.cmd("highlight DiagnosticInfo ctermfg=blue guifg=" .. vim.env.BASE16_BLUE)
vim.cmd("highlight DiagnosticHint ctermfg=white guifg=" .. vim.env.BASE16_LIGHT_FOREGROUND)

vim.cmd("highlight DiagnosticFloatingError ctermfg=red guifg=" .. vim.env.BASE16_RED)
vim.cmd("highlight DiagnosticFloatingWarn ctermfg=yellow guifg=" .. vim.env.BASE16_YELLOW)
vim.cmd("highlight DiagnosticFloatingInfo ctermfg=blue guifg=" .. vim.env.BASE16_BLUE)
vim.cmd("highlight DiagnosticFloatingHint ctermfg=white guifg=" .. vim.env.BASE16_LIGHT_FOREGROUND)

vim.cmd("highlight DiagnosticUnderlineError guisp=" .. vim.env.BASE16_RED)
vim.cmd("highlight DiagnosticUnderlineWarn guisp=" .. vim.env.BASE16_YELLOW)
vim.cmd("highlight DiagnosticUnderlineInfo guisp=" .. vim.env.BASE16_BLUE)
vim.cmd("highlight DiagnosticUnderlineHint guisp=" .. vim.env.BASE16_LIGHT_FOREGROUND)
