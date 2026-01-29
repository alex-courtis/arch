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
      cmd = "rg",
      options = {}, -- no ignore-case
    },
    replace = {
      cmd = "sed",
    },
  },
  mapping = {
    ["run_current_replace"] = {
      map = "s",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
      desc = "replace current line"
    },
    ["run_replace"] = {
      map = "S",
      cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
      desc = "replace all"
    },
    ["change_view_mode"] = {
      map = "v",
      cmd = "<cmd>lua require('spectre').change_view()<CR>",
      desc = "change result view mode"
    },
    ["delete_line"] = {
      map = "Z",
      cmd = "<cmd>lua require('spectre.actions').run_delete_line()<CR>",
      desc = "delete line",
    },
    ["toggle_line"] = {
      map = "<CR>",
      cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
      desc = "toggle item"
    },
    ["enter_file"] = {
      map = "<C-CR>",
      cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
      desc = "open file"
    },
    ["resume_last_search"] = {
      map = "<C-k>",
      cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
      desc = "repeat last search"
    },
    ["send_to_qf"] = {
      map = "oq",
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = "send all items to quickfix"
    },
    ["replace_cmd"] = {
      map = "oc",
      cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
      desc = "input replace command"
    },
    ["show_option_menu"] = {
      map = "oo",
      cmd = "<cmd>lua require('spectre').show_options()<CR>",
      desc = "show options"
    },
    ["select_template"] = {
      map = "op",
      cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
      desc = "pick template",
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
