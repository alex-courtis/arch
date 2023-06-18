local M = {}

--- Attempt to require
--- @param modname string
--- @return table|nil
function M.require_or_nil(modname)
  local ok, module = pcall(require, modname)
  if ok then
    return module
  end
  vim.notify('failed: require("' .. modname .. '")', vim.log.levels.ERROR)
end

return M
