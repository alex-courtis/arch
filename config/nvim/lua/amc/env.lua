local log = require("amc.log")

local M = {}

--- unload all modules
function M.unload(data)
  if data.file:match("init.lua$") then
    for k, _ in pairs(package.loaded) do
      if (k:match("^amc.") or k == "init") and k ~= "amc.log" then
        log.line("unloading %s", k)
        package.loaded[k] = nil
      end
    end
    log.line("unloading amc.log")
    package.loaded["amc.log"] = nil
  end
end

function M.update_path()
  vim.o.path = vim.loop.cwd() .. "/**"
end

function M.update_title()
  vim.o.titlestring = vim.fn.system("printtermtitle")
end

return M
