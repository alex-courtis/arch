local configs_ok, configs = pcall(require, "nvim-treesitter.configs")

if not configs_ok then
  return
end

local parsers = {
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

-- most of these do not look good
-- install explicitly e.g. :TSInstall cpp

-- :TSBufToggle highlight

local opts = {
  parser_install_dir = vim.fn.stdpath("data"),

  sync_install = false,

  -- TODO find a way to ensure parsers are not checked on every startup OR just auto install and disable
  -- ensure_installed = parsers,

  ignore_install = {},

  auto_install = false,

  highlight = {
    enable = true,

    disable = {},
  },
}

configs.setup(opts)
