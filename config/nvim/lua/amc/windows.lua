local buffers = require("amc.buffers")

local M = {}

local CLOSE_INC_ORDER = {
  [buffers.Special.QUICK_FIX] = 1,
  [buffers.Special.FUGITIVE] = 2,
  [buffers.Special.HELP] = 3,
  [buffers.Special.NVIM_TREE] = 4,
}

--- go to first nonspecial window, nuke if none found
--- @param wins table preferred order
local function home(wins)
  for _, w in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(w)
    if not buffers.special(buf) then
      vim.api.nvim_set_current_win(w)
      return
    end
  end

  vim.cmd.new()
  M.close_others()
end

--- if current window is special go to the topleftest non special window
--- :new and nukes when none available
function M.go_home()
  if buffers.special(0) then
    home(vim.api.nvim_list_wins())
  end
end

--- go_home if window is special otherwise go to the next topleftest non special window
function M.go_home_or_next()
  if buffers.special(0) then
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

--- close current window and return home
function M.close()
  vim.cmd.quit()
  M.go_home()
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

--- close lowest window: CLOSE_INC_ORDER, special, normal
function M.close_inc()
  -- find lowest special by order
  local lowest
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(winid)
    local special = buffers.special(buf)
    if special then
      local order = CLOSE_INC_ORDER[special] or 999
      if not lowest or order < lowest.order then
        lowest = lowest or {}
        lowest.winid = winid
        lowest.order = order
      end
    end
  end

  -- close special
  if lowest then
    vim.api.nvim_win_close(lowest.winid, true)
    return
  end

  -- close other normal
  local winid_cur = vim.api.nvim_get_current_win()
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if winid_cur ~= winid then
      vim.api.nvim_win_close(winid, true)
      return
    end
  end
end

function M.cprev()
  pcall(vim.cmd.cprev)
end

function M.cnext()
  pcall(vim.cmd.cnext)
end

--- au QuickFixCmdPost
--- @param data table
function M.open_qf_loc_win(data)
  -- open quickfix or location
  -- https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
  if data.match:sub(1, 1) == "l" then
    vim.cmd.lwindow()
  else
    vim.cmd.cwindow()
  end
end

--- au BufWinEnter
--- @param data table
function M.resize_qf_loc_win(data)
  --- resize quickfix and loclist
  if data.file == "quickfix" then
    local winid = vim.fn.bufwinid(data.buf)
    if winid ~= -1 then
      vim.api.nvim_win_set_height(winid, 15)
    end
  end
end

--- help, man vertical right
--- au BufWinEnter
function M.position_doc_window()
  if vim.o.filetype == "help" and vim.o.buftype == "help" or vim.o.filetype == "man" and vim.o.buftype == "nofile" then
    vim.cmd.wincmd("L")
  end
end

return M
