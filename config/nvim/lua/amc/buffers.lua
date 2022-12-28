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
  GIT = 6,
  DIR = 7,
  OTHER = 8,
  BLEH = 9,
}

--- &buftype is empty, name is empty, not modified
--- @param bufnr number
local function is_no_name_new(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  return vim.api.nvim_buf_get_name(bufnr) == "" and not vim.bo[bufnr].modified
end

--- wipe unwanted buffers by name
--- @param bufnr number
local function wipe_unwanted(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  for _, s in ipairs(UNWANTED_NAMES) do
    if name:find(s) then
      vim.cmd({ cmd = "bwipeout", count = bufnr })
      return
    end
  end
end

--- wipe # when it's a no-name new not visible anywhere
--- @param bufnr number
local function wipe_alt_no_name_new(bufnr)
  local bufnr_alt = vim.fn.bufnr("#")
  local winnr_alt = vim.fn.bufwinnr(bufnr_alt)

  -- alt is not visible
  if bufnr_alt ~= -1 and bufnr ~= bufnr_alt and winnr_alt == -1 and is_no_name_new(bufnr_alt) then
    vim.cmd({ cmd = "bwipeout", count = bufnr_alt })
  end
end

--- &buftype set or otherwise not a normal buffer
--- @param bufnr number
--- @return number|nil enum M.SPECIAL_TYPE
function M.special(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if filetype == "help" then
    return M.SPECIAL.HELP
  elseif buftype == "quickfix" then
    return M.SPECIAL.QUICK_FIX
  elseif filetype == "man" then
    return M.SPECIAL.MAN
  elseif filetype:match("^fugitive") then
    return M.SPECIAL.FUGITIVE
  elseif filetype == "git" then
    return M.SPECIAL.GIT
  elseif filetype == "NvimTree" then
    return M.SPECIAL.NVIM_TREE
  elseif buftype ~= "" then
    return M.SPECIAL.OTHER
  elseif vim.fn.isdirectory(bufname) ~= 0 then
    return M.SPECIAL.DIR
  end

  return nil
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

--- write to a new scratch buffer
--- @param text string newline delimited
function M.write_scratch(text)
  local bufnr = vim.api.nvim_create_buf(true, true)

  local line = 0
  for s in text:gmatch("[^\r\n]+") do
    vim.fn.appendbufline(bufnr, line, s)
    line = line + 1
  end

  vim.cmd({ cmd = "buffer", count = bufnr })
end

--- au WinClosed
function M.WinClosed(data)
  wipe_unwanted(data.buf)
end

--- au BufEnter
function M.BufEnter(data)
  wipe_alt_no_name_new(data.buf)
end

--- autowriteall doesn't cover all cases
function M.update(data)
  if vim.bo[data.buf].buftype == "" and vim.api.nvim_buf_get_name(data.buf) ~= "" then
    vim.cmd({ cmd = "update" })
  end
end

return M
