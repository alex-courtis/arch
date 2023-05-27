local buffers = require("amc.buffers")
local log = require("amc.log")
local env = require("amc.env")
local nvim_tree = require("amc.plugins.nvt")

--- wipe directory buffers
local first_dir
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if buffers.special(bufnr) == buffers.Special.DIR then
    first_dir = first_dir or vim.api.nvim_buf_get_name(bufnr)
    vim.cmd.bwipeout(bufnr)
  end
end

--- change directory to the first buffer if it is a directory
if first_dir then
  log.line("cd %s", first_dir)
  nvim_tree.startup_dir = first_dir
  vim.cmd.cd(first_dir)
end

--- record the initial cwd
env.init_cwd = vim.loop.cwd()
