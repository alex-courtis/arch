local M = {}

local SPECIAL = require("amc.enum").SPECIAL

local K = require("amc.util").K

local windows = require("amc.windows")

---no way to remap fugitive and tpope will not add
function M.attach(data)
  K.n__b("a", "=", data.buf, "Toggle Inline Diff", { remap = true })
  K.n__b("x", "X", data.buf, "Discard",            { remap = true })
end

function M.open()
  local winid = windows.winid_special(SPECIAL.fugitive)

  -- focus ourselves as fugitive resets the cursor
  if winid then
    vim.api.nvim_set_current_win(winid)
  else
    vim.cmd.Git({ mods = { emsg_silent = true } })
  end
end

function M.open_only()
  M.open()
  vim.cmd.only({ mods = { silent = true } })
end

vim.g.fugitive_summary_format = '%s  [%an]  (%ai)'

return M
