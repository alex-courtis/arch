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

-- aerial override
vim.cmd("highlight! link AerialNormal Comment")

vim.cmd("colorscheme base16")

vim.cmd("highlight Search guibg=#" .. vim.env.BASE16_orange)    -- default yellow
vim.cmd("highlight IncSearch guibg=#" .. vim.env.BASE16_yellow) -- default orange

-- nvim-tree override
vim.cmd("highlight NvimTreeOpenedHL guifg=#" .. vim.env.BASE16_default_foreground)

-- linux-16color shows 16 foreground colours but only 8 background colours
if vim.env.TERM:match("^linux") then
  -- change the low grey backgrounds to white
  local hl = vim.api.nvim_get_hl(0, {})
  for name, h in pairs(hl) do
    if type(h.ctermbg) == "number" and tonumber(h.ctermbg) >= 236 and tonumber(h.ctermbg) < 255 then
      h.ctermbg = 7
      vim.api.nvim_set_hl(0, name, h)
    end
  end

  -- ensure white background are visible
  vim.cmd("highlight CursorLine ctermfg=0")
  vim.cmd("highlight CursorLineNr ctermfg=15")
  vim.cmd("highlight CursorLineSign ctermfg=15")
  vim.cmd("highlight Folded ctermfg=0")
  vim.cmd("highlight LineNr ctermfg=0")
  vim.cmd("highlight LineNrAbove ctermfg=0")
  vim.cmd("highlight LineNrBelow ctermfg=0")
  vim.cmd("highlight SignColumn ctermfg=0")
  vim.cmd("highlight StatusLine ctermfg=15")
  vim.cmd("highlight StatusLineNC ctermfg=0")
  vim.cmd("highlight TabLine ctermfg=0")
  vim.cmd("highlight TabLineFill ctermfg=0")
  vim.cmd("highlight Visual ctermfg=0")
  vim.cmd("highlight WinBar ctermfg=0")
  vim.cmd("highlight WinBarNC ctermfg=0")
  vim.cmd("highlight WinSeparator ctermfg=7")
  vim.cmd("highlight VertSplit ctermfg=7")
end
