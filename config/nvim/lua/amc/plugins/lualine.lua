local log = require("amc.log")
local require = require("amc.require").or_nil

local lualine = require("lualine")

if not lualine then
  return
end

local filename = {
  "filename",
  symbols = {
    readonly = "",
  },
}

---@alias GitSignsType "added" | "changed" | "removed"

---@type table<GitSignsType, string>
local gs_indicator = {
  added = "+",
  changed = "~",
  removed = "-",
}

---loclist or quickfix title
---replaces :setXXlist() which can happen after list manipulation
---@return string|nil
local function qf_name()
  local loclist = vim.fn.getloclist(0, { title = 0, filewinid = 0 })
  if loclist.filewinid ~= 0 then
    if loclist.title ~= ":setloclist()" then
      return loclist.title
    end
  end

  local qflist = vim.fn.getqflist({ title = 0 })
  if qflist then
    if qflist.title ~= ":setqflist()" then
      return qflist.title
    end
  end
end

local function qf_title()
  if vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0 then
    return "Loc"
  else
    return "QF"
  end
end

---quickfix cur/total
---@return string|nil
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

---only when logging
---@return string bufnr winnr winid
local function win_buf_info()
  if not log.enabled then
    return ""
  end

  return string.format("b%d w%d i%d", vim.fn.bufnr(), vim.fn.winnr(), vim.fn.win_getid())
end

local theme, section_separators, component_separators, gs_colour

if vim.env.TERM:match("^linux") then
  section_separators = { left = "", right = "" }
  component_separators = { left = "", right = "" }

  theme = {

    -- z/y/x inherits a/b/c
    normal = {
      a = { fg = 0, bg = 7 },
      b = { fg = 7, bg = 0 },
      c = { fg = 7, bg = 0 },
    },

    -- inherits normal
    replace = {
      a = { fg = 7, bg = 3 },
    },
    insert = {
      a = { fg = 7, bg = 4 },
    },
    visual = {
      a = { fg = 7, bg = 5 },
    },
    command = {
      a = { fg = 7, bg = 1 },
    },
    terminal = {
      a = { fg = 7, bg = 1 },
    },

    inactive = {
      a = { fg = 7, bg = 0 },
      b = { fg = 7, bg = 0 },
      c = { fg = 7, bg = 0 },
    },
  }

  ---@type table<GitSignsType, table> gitsigns theme item
  gs_colour = {
    added = { fg = 2, bg = theme.normal.c.bg },
    changed = { fg = 5, bg = theme.normal.c.bg },
    removed = { fg = 1, bg = theme.normal.c.bg },
  }
else
  section_separators = { left = "", right = "" }
  component_separators = { left = "", right = "" }

  theme = {

    -- z/y/x inherits a/b/c
    normal = {
      a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_comments, gui = "bold" },
      b = { fg = "#" .. vim.env.BASE16_dark_foreground, bg = "#" .. vim.env.BASE16_lighter_background },
      c = { fg = "#" .. vim.env.BASE16_dark_foreground, bg = "#" .. vim.env.BASE16_selection_background },
    },

    -- inherits normal
    replace = {
      a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_yellow, gui = "bold" },
    },
    insert = {
      a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_blue, gui = "bold" },
    },
    visual = {
      a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_magenta, gui = "bold" },
    },
    command = {
      a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_red, gui = "bold" },
    },
    terminal = {
      a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_green, gui = "bold" },
    },

    inactive = {
      a = { fg = "#" .. vim.env.BASE16_dark_foreground, bg = "#" .. vim.env.BASE16_selection_background },
      b = { fg = "#" .. vim.env.BASE16_dark_foreground, bg = "#" .. vim.env.BASE16_selection_background },
      c = { fg = "#" .. vim.env.BASE16_dark_foreground, bg = "#" .. vim.env.BASE16_selection_background },
    },
  }

  gs_colour = {
    added = { fg = string.format("#%x", vim.api.nvim_get_hl(0, { name = "DiffAdd" }).fg), bg = theme.normal.c.bg },
    changed = { fg = string.format("#%x", vim.api.nvim_get_hl(0, { name = "DiffChange" }).fg), bg = theme.normal.c.bg },
    removed = { fg = string.format("#%x", vim.api.nvim_get_hl(0, { name = "DiffDelete" }).fg), bg = theme.normal.c.bg },
  }
end

---@param type GitSignsType
---@return fun(): table gitsigns theme item
local function gitsigns_colour(type)
  return function()
    return gs_colour[type]
  end
end

---@param type GitSignsType
---@return fun(): string
local function gitsigns_component(type)
  return function()
    if vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict[type] > 0 then
      return gs_indicator[type] .. vim.b.gitsigns_status_dict[type] .. " "
    else
      return ""
    end
  end
end

local config = {
  options = {
    theme = theme,
    section_separators = section_separators,
    component_separators = component_separators,
  },

  sections = {
    lualine_a = { filename },
    lualine_b = { "filetype" },
    lualine_c = { "diagnostics", "searchcount" },
    lualine_x = {
      {
        gitsigns_component("added"),
        color = gitsigns_colour("added"),
        padding = { left = 0, right = 0 },
        separator = "",
      },
      {
        gitsigns_component("changed"),
        color = gitsigns_colour("changed"),
        padding = { left = 0, right = 0 },
        separator = "",
      },
      {
        gitsigns_component("removed"),
        color = gitsigns_colour("removed"),
        padding = { left = 0, right = 0 },
        separator = "",
      },
      {
        win_buf_info,
      },
    },
    lualine_y = { "location", },
    lualine_z = { "progress", },
  },
  inactive_sections = {
    lualine_a = { filename },
    lualine_b = {},
    lualine_c = {},
    lualine_x = { win_buf_info },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {

    -- filetype is name
    {
      filetypes = { "fugitive", "fugitiveblame", "git", "gitcommit", "NvimTree", },
      sections = {
        lualine_a = { "filetype" },
        lualine_c = { win_buf_info },
      },
      inactive_sections = {
        lualine_a = { "filetype" },
        lualine_c = { win_buf_info },
      },
    },

    -- quickfix title is name
    {
      filetypes = { "qf" },
      sections = {
        lualine_a = { qf_name },
        lualine_b = {},
        lualine_c = { qf_progress },
        lualine_x = { win_buf_info, qf_title, },
        lualine_y = { "location", },
        lualine_z = { "progress", },
      },
      inactive_sections = {
        lualine_a = { qf_name },
        lualine_b = {},
        lualine_c = { qf_progress },
        lualine_x = { win_buf_info, },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}

-- init
lualine.setup(config)
