local M = {}
local FILE = "/tmp/nvim.log"

M.enabled = vim.env.NVIM_LOG ~= nil

function M.line(fmt, ...)
  if not M.enabled then
    return
  end

  local file = io.open(FILE, "a")
  if file then
    io.output(file)
    io.write(string.format(string.format("[%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), fmt or ""), ...))
    io.close(file)
  end
end

if M.enabled then
  vim.notify("logging to " .. FILE)
  os.remove(FILE)
  M.line("----------------")
end

return M
