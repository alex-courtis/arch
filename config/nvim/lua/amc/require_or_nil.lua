local log = require("amc.log")

---require a module, logging and printing error, returning nil on failure
---@param modname string
---@return table|nil
return function(modname)
  local ok, module = pcall(require, modname)
  if ok then
    return module
  else
    local err = string.format("%s\n%s", module, debug.traceback())
    log.line(err)

    -- print renders ^I
    err = err:gsub("\t", "    ")
    print(err)

    return nil
  end
end
