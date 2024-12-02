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
  }
}

spectre.setup(config)
