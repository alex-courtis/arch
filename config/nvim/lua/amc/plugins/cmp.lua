local require = require("amc.require").or_nil

local cmp = require("cmp")

if not cmp then
  return
end

-- see nvim-cmp/lua/cmp/config/mapping.lua

---
---nvim_lsp
---
local preset_insert = cmp.mapping.preset.insert()
cmp.setup({
  completion = {
    autocomplete = false,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = preset_insert["<C-N>"],
    ["<C-S-Space>"] = preset_insert["<C-P>"],
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    {
      name = "nvim_lsp"
    },
  }),
})
