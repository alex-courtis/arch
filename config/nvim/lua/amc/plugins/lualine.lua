local log = require("amc.log")

local lualine_ok, lualine = pcall(require, "lualine")

if not lualine_ok then
  return
end

local filename = {
  "filename",
  symbols = {
    readonly = "",
  },
}

--- loclist or quickfix title
--- replaces :setXXlist() which can happen after list manipulation
--- @return string|nil
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
    return "Location"
  else
    return "QuickFix"
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

--- only when logging
--- @return string bufnr winnr winid
local function win_buf_info()
  if not log.enabled then
    return ""
  end

  return string.format("b%d w%d i%d", vim.fn.bufnr(), vim.fn.winnr(), vim.fn.win_getid())
end

-- stylua: ignore start
local theme = {

  -- z/y/x inherits a/b/c
  normal = {
    a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_comments,            gui = "bold" },
    b = { fg = "#" .. vim.env.BASE16_dark_foreground,    bg = "#" .. vim.env.BASE16_lighter_background                },
    c = { fg = "#" .. vim.env.BASE16_dark_foreground,    bg = "#" .. vim.env.BASE16_selection_background              },
  },

  -- inherits normal
  replace = {
    a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_yellow,              gui = "bold" },
  },
  insert = {
    a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_blue,                gui = "bold" },
  },
  visual = {
    a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_magenta,             gui = "bold" },
  },
  command = {
    a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_red,                 gui = "bold" },
  },
  terminal = {
    a = { fg = "#" .. vim.env.BASE16_lighter_background, bg = "#" .. vim.env.BASE16_green,               gui = "bold" },
  },

  inactive = {
    a = { fg = "#" .. vim.env.BASE16_dark_foreground,    bg = "#" .. vim.env.BASE16_selection_background              },
    b = { fg = "#" .. vim.env.BASE16_dark_foreground,    bg = "#" .. vim.env.BASE16_selection_background              },
    c = { fg = "#" .. vim.env.BASE16_dark_foreground,    bg = "#" .. vim.env.BASE16_selection_background              },
  },
}
-- stylua: ignore end

local config = {
  options = {
    theme = theme,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },

  sections = {
    lualine_a = { filename },
    lualine_b = { "searchcount" },
    lualine_c = { "diagnostics", win_buf_info },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = { filename },
    lualine_b = {},
    lualine_c = { win_buf_info },
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
        lualine_c = { win_buf_info },
        lualine_y = { qf_title },
        lualine_z = { qf_progress },
      },
      inactive_sections = {
        lualine_a = { qf_name },
        lualine_c = { win_buf_info },
        lualine_y = { qf_title },
        lualine_z = { qf_progress },
      },
    },
  },
}

-- init
lualine.setup(config)
