local require = require("amc.require").or_nil

local K = require("amc.util").K

local render_markdown = require("render-markdown")

if not render_markdown then
  return
end

local function on_attach()
  vim.treesitter.start()
  K.n_lb("mc", ':s/- \\[ \\]/- [x]/g<CR>', 0, "Markdown: check box")
  K.n_lb("mu", ':s/- \\[x\\]/- [ ]/g<CR>', 0, "Markdown: uncheck box")
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
  sign = {
    priority = 10,
  },
}

render_markdown.setup(config);
