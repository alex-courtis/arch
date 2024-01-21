local ok, mini_base16 = pcall(require, "mini.base16")
if not ok then
  return
end

local palette = {}

for i = 0, 15, 1 do
  local hex = string.format("%02X", i)
  palette["base" .. hex] = "#" .. vim.env["BASE16_" .. hex]
end

mini_base16.setup({
  palette = palette,
  use_cterm = true,
  plugins = {
    default = true,
    ['nvim-tree/nvim-tree.lua'] = false,
  },
})

vim.g.colors_name = "base16"
