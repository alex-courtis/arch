local require = require("amc.require").or_nil

local M = {}

if not require("nvim-treesitter") then
  return
end

-- expensive, only do on demand
function M.install_base()
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
      "markdown",
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
end

return M
