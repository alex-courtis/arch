local M = {}

M.enabled = false

local function log(fmt, ...)
  local file = io.open("/tmp/nvim.log", "a")
  if file then
    io.output(file)
    io.write(string.format(string.format("[%s] %s\n", os.date "%Y-%m-%d %H:%M:%S", fmt or ""), ...))
    io.close(file)
  end
end

if vim.env.NVIM_LOG then
  M.enabled = true

  vim.notify("logging to /tmp/nvim.log")

  M.line = log

  M.line("----------------")
else
  M.line = function() end
end

return M
