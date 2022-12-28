local buffers = require("amc.buffers")
local log = require("amc.log")

--- wipe directory buffers
local dir
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if buffers.special(bufnr) == buffers.SPECIAL.DIR then
    dir = dir or vim.api.nvim_buf_get_name(bufnr)
    vim.cmd({ cmd = "bwipeout", count = bufnr })
  end
end

--- change directory to the first buffer if it is a directory
if dir then
  log.line("cd %s", dir)
  vim.cmd({ cmd = "cd", args = { dir } })
end
