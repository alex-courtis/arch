local buffers = require("amc.buffers")

local M = {}

--- go to first nonspecial window, nuke if none found
--- @param wins table preferred order
local function home(wins)
  for _, w in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(w)
    if not buffers.is_special(buf) then
      vim.api.nvim_set_current_win(w)
      return
    end
  end

  vim.notify("windows home nuking")
  vim.cmd(":new")
  M.close_others()
end

--- if current window is special go to the topleftest non special window
--- :new and nukes when none available
function M.go_home()
  if buffers.is_special(0) then
    home(vim.api.nvim_list_wins())
  end
end

--- go_home if window is special otherwise go to the next topleftest non special window
function M.go_home_or_next()
  if buffers.is_special(0) then
    M.go_home()
    return
  end

  local all = vim.api.nvim_list_wins()
  local cur = vim.api.nvim_get_current_win()

  -- current window's index
  local curi = 0
  for i, w in ipairs(all) do
    if w == cur then
      curi = i
    end
  end

  -- prefer after then before then current
  local pref = {}
  for i = curi + 1, #all, 1 do
    table.insert(pref, all[i])
  end
  for i = 1, curi - 1, 1 do
    table.insert(pref, all[i])
  end
  table.insert(pref, cur)

  home(pref)
end

--- close windows other than the current
function M.close_others()
  local win = vim.api.nvim_get_current_win()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if win ~= w then
      vim.api.nvim_win_close(w, true)
    end
  end
end

return M
