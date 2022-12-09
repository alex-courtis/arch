local M = {}

-- on creation some buffers may not have &buftype set at BufEnter time
local SPECIAL_NAMES = {
  "__Tagbar__",
  "^fugitive://",
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

return M
