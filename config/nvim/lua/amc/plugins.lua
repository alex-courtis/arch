local log = require("amc/log")

require("amc.plugins.cmp").setup()
require("amc.plugins.gitsigns").setup()
require("amc.plugins.lsp").setup()
require("amc.plugins.nvim-tree").setup()
require("amc.plugins.telescope").setup()

log.line("plugins done")
