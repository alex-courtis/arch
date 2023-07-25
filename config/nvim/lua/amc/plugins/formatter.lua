local util = require("amc.util")
local formatter = util.require_or_nil("formatter")
local formatter_format = util.require_or_nil("formatter.format")
local formatter_util = util.require_or_nil("formatter.util")

local M = {}

if not formatter or not formatter_format or not formatter_util then
  return M
end

local filetype = {
  -- stylua finding parent stylua.toml is currently non-functional when using stdin
  --   Failed to run formatter stylua. error: no file or directory found matching ''
  javascript = {
    require("formatter.filetypes.javascript").jsbeautify,
  },
  json = {
    require("formatter.filetypes.json").jsbeautify,
  },
  json5 = {
    require("formatter.filetypes.json").jsbeautify,
  },
}

--- Format buffer if it's a known filetype
--- @return boolean formatted
function M.format()
  if filetype[vim.bo.filetype] then
    vim.cmd.Format({ mods = { silent = false } })
    return true
  end
  return false
end

-- init
formatter.setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = filetype,
})

return M
