local env = require("amc.env")
local require = require("amc.require").or_nil

local M = {}

local K = require("amc.util").K

local tree = require("nvim-tree")
local api = require("nvim-tree.api")

if not tree or not api then
  return M
end

local telescope = require("amc.plugins.telescope")

local NO_STARTUP_FT = {
  "gitcommit",
  "gitrebase",
}

---Absolute paths of the node.
---@return string|nil file node
---@return string|nil dir parent node of file otherwise node
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
  if telescope then
    local _, dir = node_path_dir()
    if dir then
      telescope.find_files({ search_dirs = { dir } })
    end
  end
end

local function live_grep()
  if telescope then
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

  ---@param desc string
  ---@return vim.keymap.set.Opts
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, noremap = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.del("n", "<C-]>", { buffer = bufnr }) -- api.tree.change_root_to_node,
  vim.keymap.del("n", "<C-e>", { buffer = bufnr }) -- api.node.open.replace_tree_buffer,
  vim.keymap.del("n", "<C-k>", { buffer = bufnr }) -- api.node.show_info_popup
  vim.keymap.del("n", "<C-t>", { buffer = bufnr }) -- api.node.open.tab,
  vim.keymap.del("n", "<BS>",  { buffer = bufnr }) -- api.node.navigate.parent_close,
  vim.keymap.del("n", "[c",    { buffer = bufnr }) -- api.node.navigate.git.prev,
  vim.keymap.del("n", "]c",    { buffer = bufnr }) -- api.node.navigate.git.next,
  vim.keymap.del("n", "D",     { buffer = bufnr }) -- api.fs.trash,
  vim.keymap.del("n", "]e",    { buffer = bufnr }) -- api.node.navigate.diagnostics.next,
  vim.keymap.del("n", "[e",    { buffer = bufnr }) -- api.node.navigate.diagnostics.prev,
  vim.keymap.del("n", "f",     { buffer = bufnr }) -- api.live_filter.start
  vim.keymap.del("n", "F",     { buffer = bufnr }) -- api.live_filter.clear
  vim.keymap.del("n", "g?",    { buffer = bufnr }) -- api.tree.toggle_help,
  vim.keymap.del("n", "gy",    { buffer = bufnr }) -- api.fs.copy.absolute_path,
  vim.keymap.del("n", "y",     { buffer = bufnr }) -- api.fs.copy.filename,
  vim.keymap.del("n", "Y",     { buffer = bufnr }) -- api.fs.copy.relative_path,

  K.n__b("<C-t>", api.tree.change_root_to_parent,               bufnr, "", opts("Up"))
  K.n__b("<C-i>", api.node.show_info_popup,                     bufnr, "", opts("Info"))
  K.n__b("<C-]>", api.tree.change_root_to_node,                 bufnr, "", opts("CD"))
  K.n_lb("p",     api.node.navigate.diagnostics.prev_recursive, bufnr, "", opts("Prev Diagnostic"))
  K.n_lb(".",     api.node.navigate.diagnostics.next_recursive, bufnr, "", opts("Next Diagnostic"))
  K.n_lb("u",     api.node.navigate.opened.prev,                bufnr, "", opts("Prev Opened"))
  K.n_lb("e",     api.node.navigate.opened.next,                bufnr, "", opts("Next Opened"))
  K.n_lb("k",     api.node.navigate.git.prev_recursive,         bufnr, "", opts("Prev Git"))
  K.n_lb("j",     api.node.navigate.git.next_recursive,         bufnr, "", opts("Next Git"))
  K.n__b("'",     api.node.navigate.parent_close,               bufnr, "", opts("Close Directory"))
  K.n__b("?",     api.tree.toggle_help,                         bufnr, "", opts("Help"))
  K.n__b("O",     api.node.navigate.parent_close,               bufnr, "", opts("Close Directory"))
  K.n__b("A",     toggle_width_adaptive,                        bufnr, "", opts("Toggle Adaptive Width"))
  K.n__b("gr",    git_restore,                                  bufnr, "", opts("Git Restore"))
  K.n__b("gs",    git_stage,                                    bufnr, "", opts("Git Stage"))
  K.n__b("gu",    git_unstage,                                  bufnr, "", opts("Git Unstage"))
  K.n__b("fd",    find_files,                                   bufnr, "", opts("Find Files: Directory"))
  K.n__b(",d",    live_grep,                                    bufnr, "", opts("Live Grep: Directory"))
  K.n__b("yn",    api.fs.copy.filename,                         bufnr, "", opts("Copy Name"))
  K.n__b("yr",    api.fs.copy.relative_path,                    bufnr, "", opts("Copy Relative Path"))
  K.n__b("ys",    api.fs.copy.absolute_path,                    bufnr, "", opts("Copy Absolute Path"))
end

---@type nvim_tree.config
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
      diagnostics_placement = "right_align",
      show = {
        file = true,
        folder = false,
        folder_arrow = false,
        git = true,
        modified = true,
        hidden = false,
        diagnostics = true,
        bookmarks = true,
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
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = " H",
      info = " I",
      warning = " W",
      error = " E"
    }
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
    ignore_dirs = { "/.ccls-cache", "/build", "/node_modules", "/target", }
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
    threshold = vim.log.levels.WARN,
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

if vim.env.TERM:match("^linux") then
  config.renderer.icons.show.file = false
  config.renderer.icons.glyphs.bookmark = "m"
  config.renderer.icons.glyphs.git = {
    unstaged = "M",
    staged = "S",
    unmerged = "U",
    renamed = "R",
    untracked = "A",
    deleted = "D",
    ignored = "I",
  }
end

if vim.env.NVIM_TREE_PROFILE then
  config.log.enable = true
  config.log.types.profile = true
end

---open and find
---@param update_root boolean|nil
function M.open_find(update_root)
  api.tree.open({ find_file = true, update_root = update_root })
end

---maybe open, find and update root
function M.open_find_update_root()
  M.open_find(true)
end

---collapse then open and find
function M.collapse_find()
  api.tree.collapse_all(false)
  api.tree.open({ find_file = true })
end

---Open nvim-tree for real files or startup directory
---@param data table from autocommand
function M.vim_enter(data)
  local real_file = vim.fn.filereadable(data.file) == 1

  local temp_file = real_file and data.file:match("^/tmp")

  local ignored_ft = vim.tbl_contains(NO_STARTUP_FT, vim.bo[data.buf].ft)

  if (real_file and not temp_file and not ignored_ft) or env.startup_dir then
    -- open the tree but don't focus it
    api.tree.toggle({ focus = false })

    -- find the file if it exists
    api.tree.find_file(data.file)
  end
end

-- init
tree.setup(config)

return M
