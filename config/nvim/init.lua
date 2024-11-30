-- exit on inexistent cwd
if #(vim.fn.getcwd()) == 0 then
  vim.cmd.cquit({ count = 127 })
end

local log = require("amc.log")
local util = require("amc.util")
local require_or_nil = require("amc.require_or_nil")

log.line("---- options")
require_or_nil("amc.options")

-- installs but does not load
log.line("---- packer")
local plugins = {
  "echasnovski/mini.base16",
  "farmergreg/vim-lastplace",
  "fidian/hexmode",
  "GutenYe/json5.vim",
  "hashivim/vim-terraform",
  "haya14busa/vim-asterisk",
  "HiPhish/rainbow-delimiters.nvim",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-path",
  "hrsh7th/nvim-cmp",
  "kkharji/sqlite.lua",
  "lewis6991/gitsigns.nvim",
  "lifepillar/vim-colortemplate",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-telescope/telescope-smart-history.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-treesitter/nvim-treesitter",
  "qpkorr/vim-bufkill",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  "vim-scripts/ReplaceWithRegister",
  "ziglang/zig.vim",
  util.nvt_plugin_dir(),
}
if not vim.env.TERM:match("^linux") then
  table.insert(plugins, "nvim-tree/nvim-web-devicons")
end
if require("amc.pack")(plugins) then
  return
end

log.line("---- init early")
require("amc.init.early")

log.line("---- init plugins")
require("amc.plugins")

log.line("---- init late")
require("amc.init.late")

log.line("---- init done")
