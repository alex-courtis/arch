local require = require("amc.require").or_nil

---@type wk
local which_key = require("which-key")
local presets = require("which-key.presets")

if not which_key or not presets then
  return {}
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

for _, leader in ipairs({ "<Space>", "<BS>" }) do
  which_key.add({ { leader .. "d", group = "diagnostics", }, })
  which_key.add({ { leader .. "f", group = "find", }, })
  which_key.add({ { leader .. "g", group = "grep", }, })
  which_key.add({ { leader .. "h", group = "gitsigns", }, })
  which_key.add({ { leader .. "m", group = "make" }, })
  which_key.add({ { leader .. "t", group = "telescope" }, })
end

-- hide
which_key.add({ { "y<C-g>", hidden = true, } }) -- fugitive

return which_key
