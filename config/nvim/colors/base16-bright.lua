local mini_base16 = require("mini.base16")

local palette = {}

for i = 0, 15, 1 do
  local hex = string.format("%02X", i)
  palette["base" .. hex] = vim.env["BASE" .. hex]
end

mini_base16.setup({
  palette = palette,
  use_cterm = true,
})

vim.g.colors_name = "base16-bright"
