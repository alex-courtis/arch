require("amc.log")

require("amc.init.options")

require("amc.init.appearance")
require("amc.init.autocmds")
require("amc.init.commands")
require("amc.init.dirs")

require("packer").startup({
  {
    "ckipp01/stylua-nvim",
    "echasnovski/mini.base16",
    "editorconfig/editorconfig-vim",
    "hashivim/vim-terraform",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/nvim-cmp",
    "hrsh7th/vim-vsnip",
    "lewis6991/gitsigns.nvim",
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
    "xorid/asciitree.nvim",
    "ziglang/zig.vim",
  },
})

require("amc.init.mappings")

require("amc.plugins.cmp")
require("amc.plugins.gitsigns")
require("amc.plugins.lsp")
require("amc.plugins.lualine")
require("amc.plugins.nvim-tree")
require("amc.plugins.stylua")
require("amc.plugins.telescope")
