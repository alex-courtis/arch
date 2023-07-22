local util = require("amc.util")
local formatter = util.require_or_nil("formatter")
local formatter_format = util.require_or_nil("formatter.format")
local formatter_util = util.require_or_nil("formatter.util")

local M = {}

if not formatter or not formatter_format or not formatter_util then
  return M
end

function M.format()
  vim.cmd.Format({ mods = { silent = false } })
end

-- init
formatter.setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    lua = function()
      -- finding parent stylua.toml is currently non-functional when using stdin
      --   Failed to run formatter stylua. error: no file or directory found matching ''
      return {
        exe = "stylua",
        stdin = false,
      }
    end,
    javascript = {
      require("formatter.filetypes.javascript").jsbeautify,
    },
    json = {
      require("formatter.filetypes.json").jsbeautify,
    },
    json5 = {
      require("formatter.filetypes.json").jsbeautify,
    },
    ["*"] = {
      function()
        vim.cmd([[norm! gg=G``]])
      end,
    },
  },
})

return M
