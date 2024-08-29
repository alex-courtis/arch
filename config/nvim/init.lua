-- exit on inexistent cwd
if #(vim.fn.getcwd()) == 0 then
  vim.cmd.cquit({ count = 127 })
end

local log = require("amc.log")
local util = require("amc.util")
local require_or_nil = require("amc.require_or_nil")

log.line("---- options")
require_or_nil("amc.options")

log.line("---- pckr bootstrap")
local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
if not vim.loop.fs_stat(pckr_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/lewis6991/pckr.nvim",
    pckr_path,
  })
end
vim.opt.rtp:prepend(pckr_path)

log.line("---- pckr add")
require("pckr").add({
  { "ckipp01/stylua-nvim" },
  { "echasnovski/mini.base16" },
  { "farmergreg/vim-lastplace" },
  { "fidian/hexmode" },
  { "GutenYe/json5.vim" },
  { "hashivim/vim-terraform" },
  { "haya14busa/vim-asterisk" },
  { "HiPhish/rainbow-delimiters.nvim" },
  { "hrsh7th/cmp-nvim-lsp", requires = { "hrsh7th/nvim-cmp" } },
  { "hrsh7th/cmp-vsnip", requires = { "hrsh7th/nvim-cmp" } },
  { "hrsh7th/vim-vsnip" },
  { "kkharji/sqlite.lua" },
  { "lewis6991/gitsigns.nvim" },
  { "lifepillar/vim-colortemplate" },
  { "neovim/nvim-lspconfig" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope-smart-history.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "nvim-treesitter/nvim-treesitter" },
  { util.nvt_plugin_dir() },
  { "nvim-tree/nvim-web-devicons" },
  { "qpkorr/vim-bufkill" },
  { "tpope/vim-commentary" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-repeat" },
  { "vim-scripts/ReplaceWithRegister" },
  { "ziglang/zig.vim" },
})

log.line("---- init early")
require("amc.init.early")

log.line("---- init plugins")
require("amc.plugins")

log.line("---- init late")
require("amc.init.late")

log.line("---- init done")
