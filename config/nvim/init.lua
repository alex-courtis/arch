local log = require("amc.log")

local util = require("amc.util")

log.line("---- init options")
util.require_or_nil("amc.init.options")

-- installs but does not load
log.line("---- init pack")
local bootstrapped = require("amc.init.pack")({
  "ckipp01/stylua-nvim",
  "echasnovski/mini.base16",
  "farmergreg/vim-lastplace",
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
  "mhartington/formatter.nvim",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-smart-history.nvim",
  "nvim-tree/nvim-tree.lua",
  -- "/home/alex/src/nvim-tree/master",
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
util.require_or_nil("amc.init.appearance")
util.require_or_nil("amc.init.dirs")

log.line("---- init plugins")
util.require_or_nil("amc.plugins.cmp")
util.require_or_nil("amc.plugins.gitsigns")
util.require_or_nil("amc.plugins.formatter")
util.require_or_nil("amc.plugins.lsp")
util.require_or_nil("amc.plugins.lualine")
util.require_or_nil("amc.plugins.nvt")
util.require_or_nil("amc.plugins.stylua")
util.require_or_nil("amc.plugins.telescope")

log.line("---- init late")
util.require_or_nil("amc.init.autocmds")
util.require_or_nil("amc.init.commands")
util.require_or_nil("amc.init.mappings")

log.line("---- init done")
