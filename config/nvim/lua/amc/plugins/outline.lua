local require = require("amc.require").or_nil

local outline = require("outline")

if not outline then
  return
end

outline.setup({
  outline_window = {
    split_command = "above 25split",
  },
  outline_items = {
    show_symbol_details = false,
    auto_update_events = {
      items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost", "LspAttach", },
    },
  },
  keymaps = {
    close = {},
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
      openscad = {
        exclude = true,
        "Variable",
      },
    },
  },
})

return outline
