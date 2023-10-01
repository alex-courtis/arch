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
vim.cmd("highlight! link NvimTreeWindowPicker lualine_a_insert")
vim.cmd("highlight NvimTreeGitDirty ctermfg=magenta guifg=#" .. vim.env.BASE16_magenta)
vim.cmd("highlight NvimTreeGitDeleted ctermfg=red guifg=#" .. vim.env.BASE16_red)
vim.cmd("highlight NvimTreeGitStaged ctermfg=yellow guifg=#" .. vim.env.BASE16_orange)
vim.cmd("highlight NvimTreeGitMerge	ctermfg=blue guifg=#" .. vim.env.BASE16_blue)
vim.cmd("highlight NvimTreeGitNew ctermfg=green guifg=#" .. vim.env.BASE16_green)
vim.cmd("highlight NvimTreeModifiedFile ctermfg=magenta guifg=#" .. vim.env.BASE16_magenta)

vim.cmd("highlight! link NvimTreeNormal Comment")
vim.cmd("highlight! link NvimTreeOpenedFile DiagnosticHint")

vim.cmd("highlight! link NvimTreeExecFile NvimTreeNormal")
vim.cmd("highlight! link NvimTreeSymLink NvimTreeNormal")

-- override mini.base16
vim.cmd("highlight DiagnosticError ctermfg=red guifg=#" .. vim.env.BASE16_red)
vim.cmd("highlight DiagnosticWarn ctermfg=yellow guifg=#" .. vim.env.BASE16_yellow)
vim.cmd("highlight DiagnosticInfo ctermfg=blue guifg=#" .. vim.env.BASE16_blue)
vim.cmd("highlight DiagnosticHint ctermfg=white guifg=#" .. vim.env.BASE16_light_foreground)

vim.cmd("highlight DiagnosticFloatingError ctermfg=red guifg=#" .. vim.env.BASE16_red)
vim.cmd("highlight DiagnosticFloatingWarn ctermfg=yellow guifg=#" .. vim.env.BASE16_yellow)
vim.cmd("highlight DiagnosticFloatingInfo ctermfg=blue guifg=#" .. vim.env.BASE16_blue)
vim.cmd("highlight DiagnosticFloatingHint ctermfg=white guifg=#" .. vim.env.BASE16_light_foreground)

vim.cmd("highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl guisp=#" .. vim.env.BASE16_red)
vim.cmd("highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl guisp=#" .. vim.env.BASE16_yellow)
vim.cmd("highlight DiagnosticUnderlineInfo cterm=undercurl gui=undercurl guisp=#" .. vim.env.BASE16_blue)
vim.cmd("highlight DiagnosticUnderlineHint cterm=undercurl gui=undercurl guisp=#" .. vim.env.BASE16_light_foreground)
vim.cmd("highlight DiagnosticUnderlineOk cterm=undercurl gui=undercurl guisp=#" .. vim.env.BASE16_light_foreground)

vim.cmd("highlight link NvimTreeLspDiagnosticsErrorText DiagnosticUnderlineError")
vim.cmd("highlight link NvimTreeLspDiagnosticsWarningText DiagnosticUnderlineWarn")
vim.cmd("highlight link NvimTreeLspDiagnosticsInfoText DiagnosticUnderlineInfo")
vim.cmd("highlight link NvimTreeLspDiagnosticsHintText DiagnosticUnderlineHint")

vim.cmd("highlight link NvimTreeLspDiagnosticsErrorFolderText DiagnosticUnderlineError")
vim.cmd("highlight link NvimTreeLspDiagnosticsWarningFolderText DiagnosticUnderlineWarn")
vim.cmd("highlight link NvimTreeLspDiagnosticsInfoFolderText DiagnosticUnderlineInfo")
vim.cmd("highlight link NvimTreeLspDiagnosticsHintFolderText DiagnosticUnderlineHint")

