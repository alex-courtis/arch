local lualine = require("lualine")

local name = require("lualine.components.filename"):extend()
local ftname = require("lualine.components.filetype"):extend()
local ft = require("lualine.components.filetype"):extend()

local FT_IS_FILENAME = {
  fugitiveblame = true,
  qf = true,
  git = true,
}

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

function name:init(options)
  name.super.init(self, options)

  -- remove [-]
  self.options.symbols.readonly = nil
end

function name:update_status()
  if FT_IS_FILENAME[vim.bo.filetype] then
    return nil
  else
    return self.super.update_status(self)
  end
end

function ft:update_status()
  if FT_IS_FILENAME[vim.bo.filetype] then
    return nil
  else
    return self.super.update_status(self)
  end
end

function ftname:update_status()
  if FT_IS_FILENAME[vim.bo.filetype] then
    return self.super.update_status(self)
  else
    return nil
  end
end

lualine.setup({
  options = {
    theme = theme,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "diagnostics", name, ftname },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { ft },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { "diagnostics", name, ftname },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { ft },
    lualine_z = {},
  },
  extensions = { "nvim-tree", "fugitive", "man" },
})

vim.o.showmode = false
