local M = {}

-- special buffers that have no buftype
local SPECIAL_NAMES = {
  "^man://",
}

-- unwanted buffers after they go away
local UNWANTED_NAMES = {
  "^man://",
}

--- &buftype is set or name in SPECIAL_NAME
--- @param bufnr number
--- @return boolean
function M.is_special(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  if vim.bo[bufnr].buftype ~= "" then
    return true
  end

  for _, s in ipairs(SPECIAL_NAMES) do
    if name:find(s) then
      return true
    end
  end

  return false
end

--- &buftype is empty, name is empty, not modified
function M.is_no_name_new(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  return vim.api.nvim_buf_get_name(bufnr) == "" and not vim.bo[bufnr].modified
end

--- b# if # exists and % and # are not special
function M.safe_hash()
  local prev = vim.fn.bufnr("#")
  if prev == -1 or M.is_special(prev) then
    return
  end

  local cur = vim.fn.bufnr("%")
  if M.is_special(cur) then
    return
  end

  vim.cmd(":b#")
end

function M.back()
  if not M.is_special(0) then
    vim.cmd("silent BB")
  end
end

function M.forward()
  if not M.is_special(0) then
    vim.cmd("silent BF")
  end
end

--- wipe unwanted buffers
function M.wipe_unwanted(data)
  local name = vim.api.nvim_buf_get_name(data.buf)

  for _, s in ipairs(UNWANTED_NAMES) do
    if name:find(s) then
      vim.cmd({ cmd = "bwipeout", count = data.buf })
      return
    end
  end
end

--- wipe # when it's a no-name new not visible anywhere
function M.wipe_alt_no_name_new(data)
  local buf_alt = vim.fn.bufnr("#")
  local win_alt = vim.fn.bufwinnr(buf_alt)

  -- alt is not visible
  if buf_alt ~= -1 and data.buf ~= buf_alt and win_alt == -1 and M.is_no_name_new(buf_alt) then
    vim.cmd({ cmd = "bwipeout", count = buf_alt })
  end
end

return M
