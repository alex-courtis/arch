-- prevent netrw from loading
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- general options
vim.o.autowriteall = true
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.listchars = vim.o.listchars .. ",space:·"
vim.o.mouse = "a"
vim.o.number = true
vim.o.pumheight = 15
vim.o.pumwidth = 30
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.showmode = false
vim.o.shortmess = vim.o.shortmess .. "S" -- no search count
vim.o.smartcase = true
vim.o.switchbuf = "useopen,uselast"
vim.o.tabstop = 4
vim.o.tags = "**/tags"
vim.o.title = true
vim.o.undofile = true
vim.o.wrapscan = false

-- error format
vim.o.errorformat = "%.%#[   LINE   ] --- %f:%l:%m," .. vim.o.errorformat -- cmocka
vim.o.errorformat = "make: *** [%f:%l:%m," .. vim.o.errorformat -- errors in makefiles themselves

-- legacy plugin options
vim.g.BufKillCreateMappings = 0
vim.g.zig_build_makeprg_params = "-Dxwayland --prefix ~/.local install"

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

require("amc.init.appearance")
require("amc.init.autocmd")
require("amc.init.cmd")
require("amc.init.env")
require("amc.init.mappings")

require("amc.plugins.cmp")
require("amc.plugins.gitsigns")
require("amc.plugins.lsp")
require("amc.plugins.lualine")
require("amc.plugins.nvim-tree")
require("amc.plugins.stylua")
require("amc.plugins.telescope")
