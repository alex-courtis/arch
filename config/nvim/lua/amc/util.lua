local log = require("amc.log")

local M = {}

local required = {}

---require, logging first
---@param modname string
---@return table
function M.require(modname)
  if not vim.tbl_contains(required, modname) then
    log.line('require("' .. modname .. '")')
  end

  table.insert(required, modname)
  return require(modname)
end

---Attempt to require, notifying errors
---@param modname string
---@return table|nil
function M.require_or_nil(modname)
  if not vim.tbl_contains(required, modname) then
    log.line('require_safely("' .. modname .. '")')
  end

  local ok, res = pcall(require, modname)
  if ok and res then
    return res
  end

  if not vim.tbl_contains(required, modname) then
    vim.notify('failed: require_safely("' .. modname .. '"): ' .. res, vim.log.levels.ERROR)
  end

  table.insert(required, modname)
end

---Read .nvt-dir and return first path containing /lua/nvim-tree.lua
---@return string dir from file otherwise "nvim-tree/nvim-tree.lua"
function M.nvt_plugin_dir()
  local config_file_path = vim.fn.stdpath("config") .. "/.nvt-dir"
  if vim.loop.fs_stat(config_file_path) then
    for nvt_dir in io.lines(config_file_path) do
      if vim.loop.fs_stat(nvt_dir .. "/lua/nvim-tree.lua") then
        return nvt_dir
      end
    end
  end
  return "nvim-tree/nvim-tree.lua"
end

return M
