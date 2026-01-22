local require = require("amc.require").or_nil

local util = require("amc.util")

local spectre = require("spectre")
local spectre_utils = require("spectre.utils")

if not spectre then
  return
end

local M = {}

---@type SpectreConfig
local config = {
  is_insert_mode = true,
  is_block_ui_break = true,
  live_update = true,
  open_cmd = "above new",
  default = {
    find = {
      options = {}, -- no ignore-case
    },
  },
  mapping = {
    ["run_current_replace"] = {
      map = "r",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
      desc = "replace current line"
    },
    ["run_replace"] = {
      map = "R",
      cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
      desc = "replace all"
    },
  },
}

spectre.setup(config)

---Open spectre, focusing the replace input
---@param search_text string
---@param replace_text? string
---@param is_insert_mode boolean
local function open(search_text, replace_text, is_insert_mode)
  spectre.open({
    search_text = search_text,
    replace_text = replace_text,
    is_insert_mode = is_insert_mode,
  })
  spectre.tab()
end

---@param keep? boolean
function M.open_cword(keep)
  local cword = vim.fn.expand("<cword>")
  open(cword, keep and cword or nil, not keep)
end

function M.open_cword_keep()
  M.open_cword(true)
end

---@param keep? boolean
function M.open_visual(keep)
  -- spectre expects us to be in normal mode for it to scrape the selection
  vim.api.nvim_feedkeys(util.ESC, "x", false)
  local vis = spectre_utils.get_visual_selection()
  open(vis, keep and vis or nil, not keep)
end

function M.open_visual_keep()
  M.open_visual(true)
end

return M
