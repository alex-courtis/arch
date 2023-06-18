local util = require("amc.util")
local stylua = util.require_or_nil("stylua-nvim")

local M = {}

if not stylua then
  return M
end

local config = {
  error_display_strategy = "loclist",
}

-- init
stylua.setup(config)

return M
