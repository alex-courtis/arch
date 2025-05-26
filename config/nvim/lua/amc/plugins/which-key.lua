local require = require("amc.require").or_nil

local M = {}

---@type wk
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
    mappings = false,
    rules = {
      { pattern = "fugitive", name = "git" },
    },
  },
}

which_key.setup(opts)

which_key.add({ { "<BS>", mode = { "n", "v", }, group = "leader" }, })
which_key.add({ { "<Space>", mode = { "n", "v", }, group = "leader" }, })
for _, leader in ipairs({ "<Space>", "<BS>" }) do
  which_key.add({ { leader .. "c", mode = { "n" }, group = "telescope" }, })
  which_key.add({ { leader .. "d", mode = { "n" }, group = "diagnostics", }, })
  which_key.add({ { leader .. "f", mode = { "n" }, group = "find", }, })
  which_key.add({ { leader .. "g", mode = { "n", "v", }, group = "grep", }, })
  which_key.add({ { leader .. "h", mode = { "n" }, group = "git", }, })
  which_key.add({ { leader .. "m", mode = { "n" }, group = "make" }, })
end

-- hide
which_key.add({ { "y<C-g>", hidden = true, } }) -- fugitive

function M.show()
  which_key.show({})
end

function M.show_local()
  which_key.show({ global = false })
end

return M
