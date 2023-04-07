require("amc.log")

require("amc.init.options")

-- installs but does not load
local bootstrapped = require("amc.init.pack")({
  "antosha417/nvim-lsp-file-operations",
  "ckipp01/stylua-nvim",
  "echasnovski/mini.base16",
  "editorconfig/editorconfig-vim",
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
  "lewis6991/gitsigns.nvim",
  "lifepillar/vim-colortemplate",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-tree/nvim-tree.lua",
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

require("amc.plugins.cmp").init()
require("amc.plugins.gitsigns").init()
require("amc.plugins.lsp").init()
require("amc.plugins.lualine").init()
require("amc.plugins.nvt").init()
require("amc.plugins.stylua").init()
require("amc.plugins.telescope").init()

require("amc.init.mappings")
