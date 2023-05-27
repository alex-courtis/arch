local util = require("amc.util")
local tree = util.require_or_nil("nvim-tree")
local api = util.require_or_nil("nvim-tree.api")
local lsp_file_operations = util.require_or_nil("lsp-file-operations")

local M = {
  -- maybe set by dirs.lua
  startup_dir = nil,
}

local IGNORED_FT = {
  "gitcommit",
}

local function on_attach(bufnr)
  if not api then
    return
  end

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- stylua: ignore start
  vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr })
  vim.keymap.del('n', 'D',              { buffer = bufnr })
  vim.keymap.del('n', '[e',             { buffer = bufnr })
  vim.keymap.del('n', ']e',             { buffer = bufnr })
  vim.keymap.del('n', '[c',             { buffer = bufnr })
  vim.keymap.del('n', ']c',             { buffer = bufnr })
  vim.keymap.del('n', 'g?',             { buffer = bufnr })
  vim.keymap.del('n', '<BS>',           { buffer = bufnr })
  vim.keymap.del('n', '<C-e>',          { buffer = bufnr })

  vim.keymap.set('n', '<C-t>',    api.tree.change_root_to_parent,     opts('Up'))
  vim.keymap.set('n', 'O',        api.node.navigate.parent_close,     opts('Close Directory'))
  vim.keymap.set('n', '<Space>t', api.tree.change_root_to_node,       opts('CD'))
  vim.keymap.set('n', '<BS>t',    api.tree.change_root_to_node,       opts('CD'))
  vim.keymap.set('n', '<Space>p', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  vim.keymap.set('n', '<BS>p',    api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  vim.keymap.set('n', '<Space>.', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  vim.keymap.set('n', '<BS>.',    api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  vim.keymap.set('n', '<Space>u', api.node.navigate.opened.prev,      opts('Prev Opened'))
  vim.keymap.set('n', '<BS>u',    api.node.navigate.opened.prev,      opts('Prev Opened'))
  vim.keymap.set('n', '<Space>e', api.node.navigate.opened.next,      opts('Next Opened'))
  vim.keymap.set('n', '<BS>e',    api.node.navigate.opened.next,      opts('Next Opened'))
  vim.keymap.set('n', '<Space>k', api.node.navigate.git.prev,         opts('Prev Git'))
  vim.keymap.set('n', '<BS>k',    api.node.navigate.git.prev,         opts('Prev Git'))
  vim.keymap.set('n', '<Space>j', api.node.navigate.git.next,         opts('Next Git'))
  vim.keymap.set('n', '<BS>j',    api.node.navigate.git.next,         opts('Next Git'))
  vim.keymap.set('n', "'",        api.node.navigate.parent_close,     opts('Close Directory'))
  vim.keymap.set('n', '?',        api.tree.toggle_help,               opts('Help'))
  -- stylua: ignore end
end

local config = {
  hijack_cursor = true,
  sync_root_with_cwd = true,
  prefer_startup_root = true,
  on_attach = on_attach,
  view = {
    adaptive_size = false,
  },
  renderer = {
    full_name = true,
    group_empty = true,
    highlight_opened_files = "name",
    root_folder_modifier = ":t",
    special_files = {},
    symlink_destination = false,
    indent_markers = {
      enable = true,
    },
    icons = {
      git_placement = "signcolumn",
      show = {
        file = true,
        folder = false,
        folder_arrow = false,
        git = true,
      },
      glyphs = {
        modified = "[+]",
      },
    },
  },
  update_focused_file = {
    enable = true,
    ignore_list = {
      -- ft
      "help",
      "git",
      -- bufname
      "fugitiveblame",
    },
  },
  git = {
    timeout = 800,
    show_on_open_dirs = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    severity = {
      min = vim.diagnostic.severity.INFO,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  filters = {
    custom = {
      "^.git$",
    },
  },
  modified = {
    enable = true,
    show_on_open_dirs = false,
  },
  actions = {
    change_dir = {
      enable = true,
      global = true,
    },
    open_file = {
      resize_window = true,
      window_picker = {
        chars = "aoeui",
      },
    },
    remove_file = {
      close_window = false,
    },
  },
  experimental = {
  },
  log = {
    enable = false,
    truncate = true,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      dev = true,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },
}

if vim.env.NVIM_TREE_PROFILE then
  config.log.enable = true
  config.log.types.profile = true
end

--- open and find
--- @param update_root boolean
local function open_find(update_root)
  if not api then
    return
  end

  api.tree.open({ find_file = true, update_root = update_root })
end

--- maybe open and find
function M.open_find()
  open_find(false)
end

--- mapbe open, find and update root
function M.open_find_update_root()
  open_find(true)
end

--- collapse then open and find
function M.collapse_find()
  if not api then
    return
  end

  api.tree.collapse_all(false)
  api.tree.open({ find_file = true })
end

--- Open nvim-tree for real files or startup directory
--- @param data table from autocommand
function M.open_nvim_tree(data)
  if not api then
    return
  end

  local real_file = vim.fn.filereadable(data.file) == 1

  local ignored_ft = vim.tbl_contains(IGNORED_FT, vim.bo[data.buf].ft)

  if (real_file and not ignored_ft) or M.startup_dir then
    -- open the tree but don't focus it
    api.tree.toggle({ focus = false })

    -- find the file if it exists
    api.tree.find_file(data.file)
  end
end

function M.init()
  if tree then
    tree.setup(config)
  end
  if lsp_file_operations then
    lsp_file_operations.setup({})
  end
end

return M
