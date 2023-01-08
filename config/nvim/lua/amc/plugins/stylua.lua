local stylua = require("stylua-nvim")

local M = {}

function M.init()
  stylua.setup({
    error_display_strategy = "loclist",
  })
end

return M
