local lualine = require("lualine")

local theme = {
  -- z/y/x inherits a/b/c
  normal = {
    a = { fg = vim.env.BASE01, bg = vim.env.BASE03, gui = "bold" },
    b = { fg = vim.env.BASE04, bg = vim.env.BASE02 }, -- dark fg, sel bg
    c = { fg = vim.env.BASE04, bg = vim.env.BASE02 },
  },

  -- inherits normal
  replace = {
    a = { fg = vim.env.BASE01, bg = vim.env.BASE0A, gui = "bold" }, -- YELLOW
  },
  insert = {
    a = { fg = vim.env.BASE01, bg = vim.env.BASE0D, gui = "bold" }, -- BLUE
  },
  visual = {
    a = { fg = vim.env.BASE01, bg = vim.env.BASE0E, gui = "bold" }, -- MAGENTA
  },
  command = {
    a = { fg = vim.env.BASE01, bg = vim.env.BASE08, gui = "bold" }, -- RED
  },
  terminal = {
    a = { fg = vim.env.BASE01, bg = vim.env.BASE0B, gui = "bold" }, -- GREEN
  },

  inactive = {
    a = { fg = vim.env.BASE04, bg = vim.env.BASE02 }, -- dark fg, sel bg
    b = { fg = vim.env.BASE04, bg = vim.env.BASE02 },
    c = { fg = vim.env.BASE04, bg = vim.env.BASE02 },
  },
}

local filetype_name = {
  {
    "filetype",
    icon_only = true,
  },
  {
    "filename",
    symbols = {
      readonly = "",
    },
  },
}

--- quickfix title
--- Loc list title is problematic, especially with telescope. Don't use loc list.
--- @return string|nil
local function qf_title()
  local list = vim.fn.getqflist({ title = 0 })
  if list then
    return list.title
  else
    return nil
  end
end

--- quickfix cur/total
--- @return string|nil
local function qf_progress()
  local list = vim.fn.getqflist({ idx = 0, items = 0 })
  if not list then
    return nil
  end

  local total, cur = 0, 0

  for i, item in ipairs(list.items) do
    if item.valid == 1 then
      total = total + 1
      if list.idx == i then
        cur = total
      end
    end
  end

  return string.format("%d/%d", cur, total)
end

lualine.setup({
  options = {
    theme = theme,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },

  sections = {
    lualine_a = filetype_name,
    lualine_b = { "diagnostics" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "searchcount" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = filetype_name,
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {

    -- filetype is name
    {
      filetypes = { "fugitive", "fugitiveblame", "git", "gitcommit", "NvimTree" },
      sections = {
        lualine_a = { "filetype" },
      },
      inactive_sections = {
        lualine_a = { "filetype" },
      },
    },

    -- quickfix title is name
    {
      filetypes = { "qf" },
      sections = {
        lualine_a = { qf_title },
        lualine_z = { qf_progress },
      },
      inactive_sections = {
        lualine_a = { qf_title },
        lualine_z = { qf_progress },
      },
    },
  },
})
