local log = require("amc.log")

---require a module, logging and printing error, returning nil on failure
---@param modname string
---@return table|nil
return function(modname)
  local ok, module = pcall(require, modname)
  if ok then
    return module
  else
    local file = log.err(string.format("%s\n%s", module, debug.traceback()))

    local mess = string.format("%s:\n%s\nlog:\n\t%s", module:gsub(":\n.*", ""), debug.traceback(), file)

    -- print renders ^I
    mess = mess:gsub("\t", "    ")
    print(mess)

    return nil
  end
end
