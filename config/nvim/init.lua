require("amc.log")

require("amc.init.options")

-- installs but does not load
local bootstrapped = require("amc.init.pack")({
  "ckipp01/stylua-nvim",
  "echasnovski/mini.base16",
  "GutenYe/json5.vim",
  "hashivim/vim-terraform",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-path",
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

require("amc.init.appearance")
require("amc.init.autocmds")
require("amc.init.commands")
require("amc.init.dirs")

require("amc.plugins.cmp")
require("amc.plugins.gitsigns")
require("amc.plugins.formatter")
require("amc.plugins.lsp")
require("amc.plugins.lualine")
require("amc.plugins.nvt")
require("amc.plugins.stylua")
require("amc.plugins.telescope")

require("amc.init.mappings")
