local require = require("amc.require").or_nil

local outline = require("outline")

if not outline then
  return
end

outline.setup({
  outline_window = {
    split_command = "above 25split",
    no_provider_message = "",
  },
  outline_items = {
    show_symbol_details = false,
    auto_update_events = {
      items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost", "LspAttach", "LspDetach", "LspTokenUpdate", "LspNotify", },
    },
  },
  keymaps = {
    close = {},
  },
  symbols = {
    -- see :help outline-configuration icons
    filter = {
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
      -- prevents everything being shown from the attached buffer
      NvimTree = {},
    },
    icons = {
      Array = { icon = "", hl = "Identifier" },
      Boolean = { icon = "", hl = "Boolean" },
      Class = { icon = "", hl = "Typedef" },
      Component = { icon = "󰅴", hl = "Special" },
      Constant = { icon = "", hl = "Constant" },
      Constructor = { icon = "", hl = "Special" },
      Enum = { icon = "", hl = "Structure" },
      EnumMember = { icon = "", hl = "String" },
      Event = { icon = "", hl = "Tag" },
      Field = { icon = "", hl = "Keyword" },
      File = { icon = "", hl = "Include" },
      Fragment = { icon = "󰅴", hl = "Repeat" },
      Function = { icon = "", hl = "Function" },
      Interface = { icon = "", hl = "Define" },
      Key = { icon = "", hl = "String" },
      Macro = { icon = " ", hl = "Macro" },
      Method = { icon = "", hl = "Label" },
      Module = { icon = "󰆧", hl = "Structure" },
      Namespace = { icon = "", hl = "Special" },
      Null = { icon = "NULL", hl = "Special" },
      Number = { icon = "", hl = "Number" },
      Object = { icon = "⦿", hl = "Identifier" },
      Operator = { icon = "", hl = "Operator" },
      Package = { icon = "", hl = "Label" },
      Parameter = { icon = " ", hl = "Character" },
      Property = { icon = "", hl = "Character" },
      StaticMethod = { icon = " ", hl = "StorageClass" },
      String = { icon = "", hl = "String" },
      Struct = { icon = "", hl = "Structure" },
      TypeAlias = { icon = " ", hl = "Structure" },
      TypeParameter = { icon = "𝙏", hl = "Structure" },
      Variable = { icon = "", hl = "Identifier" },
    },
  },
})

return outline
