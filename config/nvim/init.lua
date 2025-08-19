-- exit on inexistent cwd
if #(vim.fn.getcwd()) == 0 then
  vim.cmd.cquit({ count = 127 })
end

local log = require("amc.log")
local util = require("amc.util")
local require_or_nil = require("amc.require").or_nil

log.line("---- options")
require_or_nil("amc.options")

if vim.fn.has("nvim-0.12") == 1 then
  log.line("---- vim.pack")
  vim.pack.add({
    "https://github.com/davvid/telescope-git-grep.nvim.git",
    "https://github.com/echasnovski/mini.base16.git",
    "https://github.com/farmergreg/vim-lastplace.git",
    "https://github.com/fidian/hexmode.git",
    "https://github.com/folke/which-key.nvim.git",
    "https://github.com/GutenYe/json5.vim.git",
    "https://github.com/haya14busa/vim-asterisk.git",
    "https://github.com/HiPhish/rainbow-delimiters.nvim.git",
    "https://github.com/kkharji/sqlite.lua.git",
    { src = "https://github.com/lewis6991/gitsigns.nvim.git", version = vim.version.range("1.0") },
    "https://github.com/lifepillar/vim-colortemplate.git",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
    "https://github.com/neovim/nvim-lspconfig.git",
    "https://github.com/nvim-lua/plenary.nvim.git",
    "https://github.com/nvim-lualine/lualine.nvim.git",
    "https://github.com/nvim-pack/nvim-spectre.git",
    "https://github.com/nvim-telescope/telescope-smart-history.nvim.git",
    "https://github.com/nvim-telescope/telescope.nvim.git",
    "https://github.com/nvim-treesitter/nvim-treesitter.git",
    "https://github.com/qpkorr/vim-bufkill.git",
    "https://github.com/tpope/vim-repeat.git",
    "https://github.com/vim-scripts/ReplaceWithRegister.git",
    "https://github.com/wbthomason/packer.nvim",
    "https://github.com/tpope/vim-fugitive.git",
    util.nvt_plugin_dir(),
    not vim.env.TERM:match("^linux") and "https://github.com/nvim-tree/nvim-web-devicons.git" or nil,
  })

else
  -- installs but does not load
  log.line("---- packer")
  local plugins = {
    "davvid/telescope-git-grep.nvim",
    "echasnovski/mini.base16",
    "farmergreg/vim-lastplace",
    "fidian/hexmode",
    "folke/which-key.nvim",
    "GutenYe/json5.vim",
    "haya14busa/vim-asterisk",
    "HiPhish/rainbow-delimiters.nvim",
    "kkharji/sqlite.lua",
    { "lewis6991/gitsigns.nvim", tag="v1.0.2" },
    "lifepillar/vim-colortemplate",
    "MeanderingProgrammer/render-markdown.nvim",
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "nvim-lualine/lualine.nvim",
    "nvim-pack/nvim-spectre",
    "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
    "qpkorr/vim-bufkill",
    "tpope/vim-fugitive",
    "tpope/vim-repeat",
    "vim-scripts/ReplaceWithRegister",
    util.nvt_plugin_dir(),
  }
  if not vim.env.TERM:match("^linux") then
    table.insert(plugins, "nvim-tree/nvim-web-devicons")
  end
  if require("amc.pack")(plugins) then
    return
  end
end

log.line("---- init early")
require("amc.init.early")

log.line("---- init plugins")
require("amc.plugins")

log.line("---- init late")
require("amc.init.late")

log.line("---- init done")
