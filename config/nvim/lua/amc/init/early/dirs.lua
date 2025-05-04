local env = require("amc.env")
local log = require("amc.log")
local SPECIAL = require("amc.enum").SPECIAL

local require = require("amc.require").or_nil

local buffers = require("amc.buffers")

if buffers then
  --- wipe directory buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if buffers.special(bufnr) == SPECIAL.dir then
      env.startup_dir = vim.api.nvim_buf_get_name(bufnr)
      vim.cmd.bwipeout(bufnr)
    end
  end
end

---change directory to the first buffer if it is a directory
if env.startup_dir then
  log.line("cd %s", env.startup_dir)
  vim.cmd.cd(env.startup_dir)
end

---record the initial cwd
env.init_cwd = vim.loop.cwd()
