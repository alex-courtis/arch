local require = require("amc.require_or_nil")

local spectre = require("spectre")

if not spectre then
  return
end

---@type SpectreConfig
local config = {
  is_insert_mode = true,
  live_update = true,
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
