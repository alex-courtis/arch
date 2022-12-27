local lualine = require("lualine")

local theme = {
  -- z/y/x inherits a/b/c
  normal = {
    a = { fg = vim.env.BASE01, bg = vim.env.BASE03, gui = "bold" },
    b = { fg = vim.env.BASE04, bg = vim.env.BASE02 }, -- dark fg, sel bg
    c = { fg = vim.env.BASE04, bg = vim.env.BASE01 }, -- dark fg, light bg
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
    c = { fg = vim.env.BASE04, bg = vim.env.BASE01 }, -- dark fg, light bg
  },
}

local filename = {
  "filename",
  symbols = {
    readonly = "",
  },
}

-- Loc list title is problematic, especially with telescope. Don't use loc list.
local function qf_title()
  return vim.fn.getqflist({ title = 0 }).title
end

lualine.setup({
  options = {
    theme = theme,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },

  sections = {
    lualine_a = { "mode" },
    lualine_b = { filename },
    lualine_c = { "diagnostics" },
    lualine_x = { "searchcount" },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { filename },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "filetype" },
    lualine_z = {},
  },
  extensions = {

    -- filetype is name
    {
      filetypes = { "fugitive", "fugitiveblame", "git", "gitcommit" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "filetype" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { "filetype" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },

    -- no name
    {
      filetypes = { "NvimTree" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { "filetype" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },

    -- quickfix title is name
    {
      filetypes = { "qf" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { qf_title },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "filetype" },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { qf_title },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "filetype" },
        lualine_z = {},
      },
    },
  },
})
