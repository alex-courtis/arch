local M = {}

function M.setup()
  require("amc.plugins.cmp").setup()
  require("amc.plugins.gitsigns").setup()
  require("amc.plugins.lsp").setup()
  require("amc.plugins.nvim-tree").setup()
  require("amc.plugins.telescope").setup()
end

return M
