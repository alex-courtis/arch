local M = {}
-- local FILE = "/tmp/nvim." .. vim.fn.getpid() .. ".log"
local FILE = "/tmp/nvim.log"

M.enabled = vim.env.NVIM_LOG ~= nil

---write a line as per string.format
---@param fmt string
---@param ... any
---@return string path of log file
function M.write(fmt, ...)
  local file = io.open(FILE, "a")
  if file then
    io.output(file)
    io.write(string.format(string.format("[%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), fmt or ""), ...))
    io.close(file)
  end
  return FILE
end

---log a line as per string.format
---NOP unless $NVIM_LOG set
---@param fmt string
---@param ... any
---@return string|nil path of log file
function M.line(fmt, ...)
  if not M.enabled then
    return
  end

  return M.write(fmt, ...)
end

---always log a line as per string.format
---@param fmt string
---@param ... any
---@return string path of log file
function M.err(fmt, ...)
  return M.write(fmt, ...)
end

if M.enabled then
  vim.notify("logging to " .. FILE)
  os.remove(FILE)
  M.line("----------------")
end

return M
