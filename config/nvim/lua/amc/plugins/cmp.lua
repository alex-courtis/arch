local require = require("amc.require_or_nil")

local cmp = require("cmp")

if not cmp then
  return
end

local insert = cmp.mapping.preset.insert()

local config = {
  completion = {
    autocomplete = false,
  },
  -- see nvim-cmp/lua/cmp/config/mapping.lua
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = insert["<C-N>"],
    ["<C-S-Space>"] = insert["<C-P>"],
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }),
}

--init
cmp.setup(config)

---Jump if snippet active otherwise feed key
---@param lhs string
---@param direction vim.snippet.Direction
---@return string|nil
local function jump(lhs, direction)
  if vim.snippet.active({ direction = direction }) then
    return vim.snippet.jump(direction)
  else
    return lhs
  end
end

vim.keymap.set({ "i", "s" }, "<Tab>",   function() jump("<Tab>", 1) end,    { expr = true })
vim.keymap.set({ "i", "s" }, "<S-Tab>", function() jump("<S-Tab>", -1) end, { expr = true })
