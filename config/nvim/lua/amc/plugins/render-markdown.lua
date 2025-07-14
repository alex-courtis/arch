local require = require("amc.require").or_nil

local render_markdown = require("render-markdown")

if not render_markdown then
  return
end

---@type render.md.UserConfig
local config = {
  render_modes = true,
  checkbox = {
    enabled = true,
  },
  code = {
    enabled = true,
    border = "thin",
  },
}

render_markdown.setup(config);
