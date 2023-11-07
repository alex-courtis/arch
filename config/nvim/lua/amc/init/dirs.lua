local util = require("amc.util")
local buffers = util.require("amc.buffers")
local log = util.require("amc.log")
local env = util.require("amc.env")

--- wipe directory buffers
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if buffers.special(bufnr) == buffers.Special.DIR then
    env.startup_dir = vim.api.nvim_buf_get_name(bufnr)
    vim.cmd.bwipeout(bufnr)
  end
end

--- change directory to the first buffer if it is a directory
if env.startup_dir then
  log.line("cd %s", env.startup_dir)
  vim.cmd.cd(env.startup_dir)
end

--- record the initial cwd
env.init_cwd = vim.loop.cwd()
