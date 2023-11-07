local log = require("amc.log")

local M = {}

local required = {}

--- require, logging first
--- @param modname string
--- @return table
function M.require(modname)
  if not vim.tbl_contains(required, modname) then
    log.line('require("' .. modname .. '")')
  end

  table.insert(required, modname)
  return require(modname)
end

--- Attempt to require, notifying errors
--- @param modname string
--- @return table|nil
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

return M
