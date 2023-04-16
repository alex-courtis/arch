local M = {}

--- Attempt to require
--- @param modname string
--- @return table|nil
M.require_or_nil = function(modname)
  local ok, module = pcall(require, modname)
  if ok then
    return module
  end
  vim.notify("failed: require(\"" .. modname .. "\")", vim.log.levels.ERROR)
end

return M
