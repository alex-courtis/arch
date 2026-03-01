local SPECIAL = require("amc.enum").SPECIAL

local M = {}

-- unwanted buffers after they go away
local UNWANTED_NAMES = {
  "^man://",
}

---&buftype is empty, name is empty, not modified
---@param bufnr number
---@return boolean
local function is_no_name_new(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  return vim.api.nvim_buf_get_name(bufnr) == "" and not vim.bo[bufnr].modified
end

---au WinClosed
---wipe unwanted buffers by name
---@param data table
function M.wipe_unwanted(data)
  local name = vim.api.nvim_buf_get_name(data.buf)

  for _, s in ipairs(UNWANTED_NAMES) do
    if name:find(s) then
      vim.cmd.bwipeout(data.buf)
      return
    end
  end
end

---wipe # when it's a no-name new not visible anywhere
---au BufEnter
---@param data table
function M.wipe_no_name_new(data)

  local bufnr_alt = vim.fn.bufnr("#")
  if bufnr_alt ~= -1 and data.buf ~= bufnr_alt and vim.fn.bufwinnr(bufnr_alt) == -1 and is_no_name_new(bufnr_alt) then
    vim.cmd.bwipeout(bufnr_alt)
    return
  end
end

---au BufLeave
---au FocusLost
---autowriteall doesn't cover all cases
---@param data table|number|nil table for autocommand otherwise bufnr
function M.update(data)
  local bufnr
  if type(data) == "table" then
    bufnr = data.buf
  elseif type(data) == "number" then
    bufnr = data
  else
    bufnr = 0
  end

  local bo = vim.bo[bufnr]
  if bo and bo.buftype == "" and not bo.readonly and bo.modifiable and vim.api.nvim_buf_get_name(bufnr) ~= "" then
    vim.cmd.update()
  end
end

---&buftype set or otherwise not a normal buffer
---@param bufnr number
---@return SPECIAL|nil
function M.special(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local bufhidden = vim.bo[bufnr].bufhidden

  -- scratch is not special
  if buftype == "nofile" and bufhidden == "hide" then
    return nil
  end

  local filetype = vim.bo[bufnr].filetype
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if buftype == "help" then
    return SPECIAL.help
  elseif buftype == "quickfix" then
    return SPECIAL.quick_fix
  elseif filetype == "man" then
    return SPECIAL.man
  elseif filetype:match("^fugitive") then
    return SPECIAL.fugitive
  elseif filetype == "NvimTree" then
    return SPECIAL.nvim_tree
  elseif filetype == "Outline" then
    return SPECIAL.outline
  elseif vim.fn.isdirectory(bufname) ~= 0 then
    return SPECIAL.dir
  elseif buftype ~= "" then
    return SPECIAL.other
  end

  return nil
end

---Wipe all buffers but the current
function M.wipe_all()
  local cur = vim.api.nvim_get_current_buf()

  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if not M.special(buf) and buf ~= cur then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

---:setlocal list/nolist
function M.toggle_list()
  local list = vim.api.nvim_get_option_value("list", { scope = "local" })
  vim.api.nvim_set_option_value("list", not list, { scope = "local" })
end

---clear trailing whitespace and last searched
function M.trim_whitespace()
  vim.cmd("%s/\\s\\+$//e")
  vim.fn.setreg("/", "")
end

---write to a new scratch buffer
---@param text string newline delimited
function M.write_scratch(text)
  local bufnr = vim.api.nvim_create_buf(false, true)

  local line = 0
  if text then
    for s in text:gmatch("[^\r\n]+") do
      vim.fn.appendbufline(bufnr, line, s)
      line = line + 1
    end
  end

  vim.cmd.buffer(bufnr)
end

---Execute vimscript and write output to scratch buffer
---@param command table as per vim.api.nvim_create_user_command
function M.exec_to_buffer(command)
  local out = vim.api.nvim_exec2(command.args, { output = true })
  if out then
    M.write_scratch(out["output"])
  end
end

---Keeps roughly in sync with ~/.editorconfig, which will not be found outside of ~
---au FileType
---@param data table
function M.default_modeline(data)
  local bo = vim.bo[data.buf]
  if bo then
    vim.bo[data.buf].expandtab = true
    vim.bo[data.buf].shiftwidth = 2
    vim.bo[data.buf].softtabstop = 2
    vim.bo[data.buf].tabstop = 2
  end
end

---Set local colorcolumn when > 0 textwidth
function M.option_set_tw()
  local tw = vim.api.nvim_get_option_value("textwidth", { scope = "local" })
  local cc = tw > 0 and tostring(tw) or nil
  vim.api.nvim_set_option_value("colorcolumn", cc, { scope = "local" })
end

return M
