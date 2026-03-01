local require = require("amc.require").or_nil

local outline = require("outline")

if not outline then
  return
end

-- TODO
-- functions and methods only
-- unmap esc
-- map global navigation

outline.setup({
  outline_window = {
    split_command = "above 25split",
  },
  outline_items = {
    show_symbol_details = false,
  },
  symbols = {
    filter = {
      -- see :help outline-configuration icons
      lua = {
        exclude = true,
        "Constant",
        "Variable",
        "Object",
        "Package",
        "Number",
        "Boolean",
        "Array",
        "String",
      },
    },
  },
})
