local log = require("amc.log")

local util = require("amc.util")

log.line("---- init options")
require("amc.init.options")

-- installs but does not load
log.line("---- init pack")
local bootstrapped = require("amc.init.pack")({
  "echasnovski/mini.base16",
  "farmergreg/vim-lastplace",
  "fidian/hexmode",
  "GutenYe/json5.vim",
  "hashivim/vim-terraform",
  "haya14busa/vim-asterisk",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/nvim-cmp",
  "hrsh7th/vim-vsnip",
  "kkharji/sqlite.lua",
  "lewis6991/gitsigns.nvim",
  "lifepillar/vim-colortemplate",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-smart-history.nvim",
  util.nvt_plugin_dir(),
  "nvim-tree/nvim-web-devicons",
  "qpkorr/vim-bufkill",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  "vim-scripts/ReplaceWithRegister",
  "Yohannfra/Vim-Goto-Header",
  "ziglang/zig.vim",
})
if bootstrapped then
  return
end

log.line("---- init early")
require("amc.init.appearance")
require("amc.init.dirs")

log.line("---- init plugins")
require("amc.plugins.cmp")
require("amc.plugins.gitsigns")
require("amc.plugins.lsp")
require("amc.plugins.lualine")
require("amc.plugins.nvt")
require("amc.plugins.telescope")

log.line("---- init late")
require("amc.init.autocmds")
require("amc.init.commands")
require("amc.init.mappings")

log.line("---- init done")
