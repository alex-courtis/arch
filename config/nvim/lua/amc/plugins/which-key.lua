local require = require("amc.require_or_nil")

local which_key = require("which-key")
local presets = require("which-key.presets")

if not which_key or not presets then
  return
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
      { pattern = "fugitive", cat = "filetype", name = "git" },
    },
  }
}

which_key.setup(opts)
