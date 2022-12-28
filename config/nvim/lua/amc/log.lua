local M = {}

M.enabled = false

local function line(fmt, ...)
  local file = io.open(M.path, "a")
  if file then
    io.output(file)
    io.write(string.format((fmt or "") .. "\n", ...))
    io.close(file)
  end
end

if vim.env.NVIM_LOG then
  M.enabled = true

  M.path = string.format("/tmp/nvim.log")
  os.remove(M.path)
  vim.notify("logging to " .. M.path)

  M.line = line

  M.line("----------------")
else
  M.line = function() end
end

return M
