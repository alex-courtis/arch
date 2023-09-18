local util = require("amc.util")
local telescope = require("amc.plugins.telescope")
local tree = util.require_or_nil("nvim-tree")
local api = util.require_or_nil("nvim-tree.api")

local M = {
  -- maybe set by dirs.lua
  startup_dir = nil,
}

if not tree or not api then
  return M
end

local IGNORED_FT = {
  "gitcommit",
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
  local _, dir = node_path_dir()
  if dir then
    telescope.find_files({ search_dirs = { dir } })
  end
end

local function live_grep()
  local _, dir = node_path_dir()
  if dir then
    telescope.live_grep({ search_dirs = { dir } })
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

local function on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- stylua: ignore start
--vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
--vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
--vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
--vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bd',    api.marks.bulk.delete,                 opts('Delete Bookmarked'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
--vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
--vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
--vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
--vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
--vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
--vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
--vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
--vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
--vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
--vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
--vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))

  vim.keymap.set('n', '<C-t>',    api.tree.change_root_to_parent,     opts('Up'))
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
  vim.keymap.set('n', 'O',        api.node.navigate.parent_close,     opts('Close Directory'))
  vim.keymap.set('n', 'gr',       git_restore,                        opts('Git Restore'))
  vim.keymap.set('n', 'gs',       git_stage,                          opts('Git Stage'))
  vim.keymap.set('n', 'gu',       git_unstage,                        opts('Git Unstage'))
  vim.keymap.set('n', 'tf',       find_files,                         opts('Find Files'))
  vim.keymap.set('n', 'tg',       live_grep,                          opts('Live Grep'))
  vim.keymap.set('n', 'yn',       api.fs.copy.filename,               opts('Copy Name'))
  vim.keymap.set('n', 'yr',       api.fs.copy.relative_path,          opts('Copy Relative Path'))
  vim.keymap.set('n', 'yy',       api.fs.copy.absolute_path,          opts('Copy Absolute Path'))
  -- stylua: ignore end
end

local config = {
  hijack_cursor = true,
  sync_root_with_cwd = true,
  prefer_startup_root = true,
  on_attach = on_attach,
  renderer = {
    highlight_diagnostics = true,
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
        diagnostics = false,
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
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  filters = {
    custom = {
      "^.git$",
      "^\\~formatter",
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
  notify = {
    absolute_path = false,
  },
  experimental = {},
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
  api.tree.collapse_all(false)
  api.tree.open({ find_file = true })
end

--- Open nvim-tree for real files or startup directory
--- @param data table from autocommand
function M.vim_enter(data)
  local real_file = vim.fn.filereadable(data.file) == 1

  local ignored_ft = vim.tbl_contains(IGNORED_FT, vim.bo[data.buf].ft)

  if (real_file and not ignored_ft) or M.startup_dir then
    -- open the tree but don't focus it
    api.tree.toggle({ focus = false })

    -- find the file if it exists
    api.tree.find_file(data.file)
  end
end

-- init
tree.setup(config)

return M
