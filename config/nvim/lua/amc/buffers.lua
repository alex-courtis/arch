local M = {}

-- unwanted buffers after they go away
local UNWANTED_NAMES = {
  "^man://",
}

M.SPECIAL = {
  HELP = 1,
  QUICK_FIX = 2,
  MAN = 3,
  FUGITIVE = 4,
  NVIM_TREE = 5,
  OTHER = 6,
}

--- &buftype set or otherwise not a normal buffer
--- @param bufnr number
--- @return number|nil enum M.SPECIAL_TYPE
function M.special(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype

  if filetype == "help" then
    return M.SPECIAL.HELP
  elseif buftype == "quickfix" then
    return M.SPECIAL.QUICK_FIX
  elseif filetype == "man" then
    return M.SPECIAL.MAN
  elseif filetype:match("^fugitive") then
    return M.SPECIAL.FUGITIVE
  elseif filetype == "NvimTree" then
    return M.SPECIAL.NVIM_TREE
  elseif buftype ~= "" then
    return M.SPECIAL.OTHER
  end

  return nil
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
  if prev == -1 or M.special(prev) then
    return
  end

  local cur = vim.fn.bufnr("%")
  if M.special(cur) then
    return
  end

  vim.cmd(":b#")
end

function M.back()
  if not M.special(0) then
    vim.cmd("silent BB")
  end
end

function M.forward()
  if not M.special(0) then
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
