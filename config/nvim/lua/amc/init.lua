local log = require("amc.log")

local M = {}

function M.require(modname)
  log.line("%s START", modname)
  local module = require(modname)
  log.line("%s END", modname)
  return module
end

log.line("init.lua START", ...)

M.require("amc.appearance")

M.require("amc.plugins.cmp")
M.require("amc.plugins.gitsigns")
M.require("amc.plugins.lsp")
M.require("amc.plugins.lualine")
M.require("amc.plugins.nvim-tree")
M.require("amc.plugins.telescope")

M.require("amc.autocmd")

log.line("init.lua END", ...)
