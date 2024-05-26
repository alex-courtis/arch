local configs_ok, configs = pcall(require, "nvim-treesitter.configs")

if not configs_ok then
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

-- this checks every startup; just run it once
if false then
  opts.ensure_installed = {
    "awk",
    "bash",
    "cmake",
    "cpp",
    "c",
    "diff",
    "dockerfile",
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
    "rust",
    "sql",
    "ssh_config",
    "terraform",
    "tmux",
    "todotxt",
    "toml",
    "typescript",
    "typespec",
    "yaml",
  }
end

configs.setup(opts)

vim.opt.runtimepath:append(opts.parser_install_dir)
