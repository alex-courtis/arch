local util = require("amc.util")
local stylua = util.require_or_nil("stylua-nvim")

local M = {}

function M.init()
  if not stylua then
    return
  end

  stylua.setup({
    error_display_strategy = "loclist",
  })
end

return M
