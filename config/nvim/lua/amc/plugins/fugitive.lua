local M = {}

local SPECIAL = require("amc.enum").SPECIAL

local windows = require("amc.windows")

---no way to remap fugitive and tpope will not add
function M.attach(data)
  vim.keymap.set("n", "t", "=", { buffer = data.buf, remap = true })
  vim.keymap.set("n", "x", "X", { buffer = data.buf, remap = true })
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

return M
