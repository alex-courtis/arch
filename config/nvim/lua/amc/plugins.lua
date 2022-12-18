local log = require("amc/log")

require("amc.plugins.cmp")
require("amc.plugins.gitsigns")
require("amc.plugins.lsp")
require("amc.plugins.nvim-tree")
require("amc.plugins.telescope")

require("which-key").setup()

log.line("plugins done")
