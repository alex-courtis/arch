local log = require("amc.log")

local M = {}

---require a module, logging and printing error, returning ret on failure
---@param modname string
---@param on_fail any
---@return table|any
local function or_(modname, on_fail)
  local ok, module = pcall(require, modname)
  if ok then
    return module
  else
    local file = log.err(string.format("%s\n%s", module, debug.traceback()))

    local mess = string.format("%s:\n%s\nlog:\n\t%s", module:gsub(":\n.*", ""), debug.traceback(), file)

    -- print renders ^I
    mess = mess:gsub("\t", "    ")
    print(mess)

    return on_fail
  end
end

---require a module, logging and printing error, returning nil on failure
---@param modname string
---@return table?
function M.or_nil(modname)
  return or_(modname, nil)
end

---require a module, logging and printing error, returning {} on failure
---@param modname string
---@return table
function M.or_empty(modname)
  return or_(modname, {})
end

return M
