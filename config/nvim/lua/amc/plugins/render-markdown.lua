local require = require("amc.require").or_nil

local render_markdown = require("render-markdown")

if not render_markdown then
  return
end

local function on_attach()
  vim.treesitter.start()
end

vim.cmd("highlight! link RenderMarkdownCodeInline RenderMarkdownCode")

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
  on = {
    attach = on_attach,
  },
}

render_markdown.setup(config);
