local M = {}

local formatter_ok, formatter = pcall(require, "formatter")

if not formatter_ok then
  return M
end

local function jsbeautify()
  return {
    exe = "js-beautify",
    args = {
      "--editorconfig",
    },
    stdin = true,
  }
end

local filetype = {
  -- stylua finding parent stylua.toml is currently non-functional when using stdin
  --   Failed to run formatter stylua. error: no file or directory found matching ''
  javascript = {
    jsbeautify,
  },
  json = {
    jsbeautify,
  },
  json5 = {
    jsbeautify,
  },
}

--- Format buffer if it's a known filetype
--- @return boolean formatted
function M.format()
  if filetype[vim.bo.filetype] then
    vim.cmd.Format({ mods = { silent = false } })
    return true
  end
  return false
end

-- init
formatter.setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = filetype,
})

return M
