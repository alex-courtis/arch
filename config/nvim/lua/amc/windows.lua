local buffers = require("amc/buffers")

local M = {}

--- go to the topleftest non special window
--- :new and nukes when none available
function M.go_home()
  if not buffers.is_special(0) then
    return
  end

  local row, col, win
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(w)
    if not buffers.is_special(buf) then
      local pos = vim.fn.win_screenpos(w)
      if not win or (pos[1] <= row and pos[2] <= col) then
        row = pos[1]
        col = pos[2]
        win = w
      end
    end
  end

  if win then
    vim.api.nvim_set_current_win(win)
  else
    print("go_home nuking")
    vim.cmd(":new")
    M.close_others()
  end
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

