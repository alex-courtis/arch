local require = require("amc.require_or_nil")

local M = {}

local stylua = require("stylua-nvim")

if not stylua then
  return M
end

local config = {
  error_display_strategy = "loclist",
}

-- init
stylua.setup(config)

M.format_file = stylua.format_file

return M
