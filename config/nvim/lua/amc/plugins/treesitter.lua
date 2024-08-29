local require = require("amc.require_or_nil")

local configs = require("nvim-treesitter.configs")

if not configs then
  return
end

-- most of these do not look good
-- install explicitly e.g. :TSInstall cpp

-- :TSBufToggle highlight

local opts = {
  parser_install_dir = vim.fn.stdpath("data") .. "/treesitter",

  sync_install = false,

  ignore_install = {},

  auto_install = false,

  highlight = {
    enable = true,

    disable = {},
  },
}

configs.setup(opts)

vim.opt.runtimepath:append(opts.parser_install_dir)

-- expensive, only do on demand
vim.api.nvim_create_user_command("TSInstallBase", function()
  vim.cmd.TSInstall({
    bang = true,
    args = {
      "awk",
      "bash",
      "cmake",
      "cpp",
      "c",
      "csv",
      "diff",
      "dockerfile",
      "dot",
      "editorconfig",
      "gitattributes",
      "gitcommit",
      "git_config",
      "gitignore",
      "git_rebase",
      "go",
      "graphql",
      "html",
      "ini",
      "jq",
      "json5",
      "jsonc",
      "json",
      "luadoc",
      "luap",
      "luau",
      "make",
      "meson",
      "ninja",
      "passwd",
      "perl",
      "printf",
      "properties",
      "proto",
      "rst",
      "rust",
      "sql",
      "ssh_config",
      "terraform",
      "tmux",
      "tsv",
      "todotxt",
      "toml",
      "typescript",
      "typespec",
      "vim",
      "xml",
      "yaml",
      "zig",
    },
  })
end, {})
