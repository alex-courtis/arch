local require = require("amc.require_or_nil")

local M = {}

local which_key = require("which-key")
local presets = require("which-key.presets")

if not which_key or not presets then
  return M
end

---@type wk.Opts
local helix = presets.helix

helix.win.no_overlap = false

---@type wk.Opts
local opts = {
  delay = 1000,
  win = helix.win,
  layout = helix.layout,
  icons = {
    rules = {
      { pattern = "fugitive", name = "git" },
    },
  },
}

which_key.setup(opts)

---@param specs wk.Spec[]
function M.add(specs)
  which_key.add(specs)
end

function M.show()
  which_key.show()
end

return M
