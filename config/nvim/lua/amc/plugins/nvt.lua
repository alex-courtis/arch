local M = {}

local env = require("amc.env")

local tree_ok, tree = pcall(require, "nvim-tree")
local telescope_ok, telescope = pcall(require, "amc.plugins.telescope")

if not tree_ok then
  return M
end

local api = require("nvim-tree.api")

local NO_STARTUP_FT = {
  "gitcommit",
  "gitrebase",
}

local GIT_DISABLE_FOR_DIRS = {
  vim.env.HOME .. "/atlassian/src/jira",
  vim.env.HOME .. "/jira",
}

local FILESYSTEM_WATCHERS_IGNORE_DIRS = {
  vim.env.HOME .. "/atlassian/src/jira",
  vim.env.HOME .. "/jira",
}

--- Absolute paths of the node.
--- @return string|nil file node
--- @return string|nil dir parent node of file otherwise node
local function node_path_dir()
  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end

  if node.parent and node.type == "file" then
    return node.absolute_path, node.parent.absolute_path
  else
    return node.absolute_path, node.absolute_path
  end
end

local function find_files()
  if telescope_ok then
    local _, dir = node_path_dir()
    if dir then
      telescope.find_files({ search_dirs = { dir } })
    end
  end
end

local function live_grep()
  if telescope_ok then
    local _, dir = node_path_dir()
    if dir then
      telescope.live_grep({ search_dirs = { dir } })
    end
  end
end

local function git_stage()
  local path, dir = node_path_dir()
  if path and dir then
    vim.fn.system({ "git", "-C", dir, "stage", path })
  end
end

local function git_unstage()
  local path, dir = node_path_dir()
  if path and dir then
    vim.fn.system({ "git", "-C", dir, "restore", "--staged", path })
  end
end

local function git_restore()
  local path, dir = node_path_dir()
  if path and dir then
    vim.fn.system({ "git", "-C", dir, "restore", path })
  end
end

local function git_disable_for_dirs(path)
  for _, p in ipairs(GIT_DISABLE_FOR_DIRS) do
    if path:find(p, 1, true) == 1 then
      return true
    end
  end
  return false
end

local function filesystem_watchers_ignore_dirs(path)
  for _, p in ipairs(FILESYSTEM_WATCHERS_IGNORE_DIRS) do
    if path:find(p, 1, true) == 1 then
      return true
    end
  end
  return false
end

local VIEW_WIDTH_FIXED = 30
local view_width_max = VIEW_WIDTH_FIXED -- fixed to start, -1 for adaptive

-- toggle the width and redraw
local function toggle_width_adaptive()
  if view_width_max == -1 then
    view_width_max = VIEW_WIDTH_FIXED
  else
    view_width_max = -1
  end

  api.tree.reload()
end

-- get current view width
local function get_view_width_max()
  return view_width_max
end

local function on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- stylua: ignore start
  vim.keymap.del('n', '<C-]>', { buffer = bufnr }) -- api.tree.change_root_to_node,
  vim.keymap.del('n', '<C-e>', { buffer = bufnr }) -- api.node.open.replace_tree_buffer,
  vim.keymap.del('n', '<C-t>', { buffer = bufnr }) -- api.node.open.tab,
  vim.keymap.del('n', '<BS>',  { buffer = bufnr }) -- api.node.navigate.parent_close,
  vim.keymap.del('n', '[c',    { buffer = bufnr }) -- api.node.navigate.git.prev,
  vim.keymap.del('n', ']c',    { buffer = bufnr }) -- api.node.navigate.git.next,
  vim.keymap.del('n', 'D',     { buffer = bufnr }) -- api.fs.trash,
  vim.keymap.del('n', ']e',    { buffer = bufnr }) -- api.node.navigate.diagnostics.next,
  vim.keymap.del('n', '[e',    { buffer = bufnr }) -- api.node.navigate.diagnostics.prev,
  vim.keymap.del('n', 'g?',    { buffer = bufnr }) -- api.tree.toggle_help,
  vim.keymap.del('n', 'gy',    { buffer = bufnr }) -- api.fs.copy.absolute_path,
  vim.keymap.del('n', 'y',     { buffer = bufnr }) -- api.fs.copy.filename,
  vim.keymap.del('n', 'Y',     { buffer = bufnr }) -- api.fs.copy.relative_path,

  vim.keymap.set('n', '<C-t>',    api.tree.change_root_to_parent,               opts('Up'))
  vim.keymap.set('n', '<Space>t', api.tree.change_root_to_node,                 opts('CD'))
  vim.keymap.set('n', '<BS>t',    api.tree.change_root_to_node,                 opts('CD'))
  vim.keymap.set('n', '<Space>p', api.node.navigate.diagnostics.prev_recursive, opts('Prev Diagnostic'))
  vim.keymap.set('n', '<BS>p',    api.node.navigate.diagnostics.prev_recursive, opts('Prev Diagnostic'))
  vim.keymap.set('n', '<Space>.', api.node.navigate.diagnostics.next_recursive, opts('Next Diagnostic'))
  vim.keymap.set('n', '<BS>.',    api.node.navigate.diagnostics.next_recursive, opts('Next Diagnostic'))
  vim.keymap.set('n', '<Space>u', api.node.navigate.opened.prev,                opts('Prev Opened'))
  vim.keymap.set('n', '<BS>u',    api.node.navigate.opened.prev,                opts('Prev Opened'))
  vim.keymap.set('n', '<Space>e', api.node.navigate.opened.next,                opts('Next Opened'))
  vim.keymap.set('n', '<BS>e',    api.node.navigate.opened.next,                opts('Next Opened'))
  vim.keymap.set('n', '<Space>k', api.node.navigate.git.prev_recursive,         opts('Prev Git'))
  vim.keymap.set('n', '<BS>k',    api.node.navigate.git.prev_recursive,         opts('Prev Git'))
  vim.keymap.set('n', '<Space>j', api.node.navigate.git.next_recursive,         opts('Next Git'))
  vim.keymap.set('n', '<BS>j',    api.node.navigate.git.next_recursive,         opts('Next Git'))
  vim.keymap.set('n', "'",        api.node.navigate.parent_close,               opts('Close Directory'))
  vim.keymap.set('n', '?',        api.tree.toggle_help,                         opts('Help'))
  vim.keymap.set('n', 'O',        api.node.navigate.parent_close,               opts('Close Directory'))
  vim.keymap.set('n', 'A',        toggle_width_adaptive,                        opts('Toggle Adaptive Width'))
  vim.keymap.set('n', 'gr',       git_restore,                                  opts('Git Restore'))
  vim.keymap.set('n', 'gs',       git_stage,                                    opts('Git Stage'))
  vim.keymap.set('n', 'gu',       git_unstage,                                  opts('Git Unstage'))
  vim.keymap.set('n', 'tf',       find_files,                                   opts('Find Files'))
  vim.keymap.set('n', 'tg',       live_grep,                                    opts('Live Grep'))
  vim.keymap.set('n', 'yn',       api.fs.copy.filename,                         opts('Copy Name'))
  vim.keymap.set('n', 'yr',       api.fs.copy.relative_path,                    opts('Copy Relative Path'))
  vim.keymap.set('n', 'ya',       api.fs.copy.absolute_path,                    opts('Copy Absolute Path'))
  -- stylua: ignore end
end

local config = {
  hijack_cursor = true,
  sync_root_with_cwd = true,
  prefer_startup_root = true,
  on_attach = on_attach,
  view = {
    width = {
      max = get_view_width_max,
    },
  },
  renderer = {
    hidden_display = "simple",
    highlight_git = "none",
    highlight_diagnostics = "name",
    highlight_opened_files = "name",
    highlight_modified = "none",
    highlight_bookmarks = "name",
    highlight_clipboard = "name",
    full_name = true,
    group_empty = true,
    root_folder_label = ":~",
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
        modified = true,
        git = true,
        diagnostics = false,
        bookmarks = false,
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
    exclude = function(event)
      return event.file:find(vim.fn.getcwd() .. "/.git/", 1, true) == 1
    end,
  },
  git = {
    timeout = 800,
    show_on_open_dirs = false,
    disable_for_dirs = git_disable_for_dirs,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  filters = {
    custom = {
      "^\\~formatter",
    },
  },
  modified = {
    enable = true,
    show_on_open_dirs = false,
  },
  filesystem_watchers = {
    ignore_dirs = filesystem_watchers_ignore_dirs,
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
  notify = {
    absolute_path = false,
  },
  experimental = {
    actions = {
      open_file = {
        relative_path = true,
      },
    },
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
--- @param update_root boolean|nil
function M.open_find(update_root)
  api.tree.open({ find_file = true, update_root = update_root })
end

--- maybe open, find and update root
function M.open_find_update_root()
  M.open_find(true)
end

--- collapse then open and find
function M.collapse_find()
  api.tree.collapse_all(false)
  api.tree.open({ find_file = true })
end

--- Open nvim-tree for real files or startup directory
--- @param data table from autocommand
function M.vim_enter(data)
  local real_file = vim.fn.filereadable(data.file) == 1

  local ignored_ft = vim.tbl_contains(NO_STARTUP_FT, vim.bo[data.buf].ft)

  if (real_file and not ignored_ft) or env.startup_dir then
    -- open the tree but don't focus it
    api.tree.toggle({ focus = false })

    -- find the file if it exists
    api.tree.find_file(data.file)
  end
end

-- init
tree.setup(config)

return M
