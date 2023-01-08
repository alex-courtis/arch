local tree = require("nvim-tree")
local api = require("nvim-tree.api")

local M = {}

local function print_node_path(node)
  print(node.absolute_path)
end

local config = {
  hijack_cursor = true,
  open_on_setup = true,
  open_on_setup_file = true,
  sync_root_with_cwd = true,
  prefer_startup_root = true,
  ignore_ft_on_setup = {
    "gitcommit",
  },
  view = {
    adaptive_size = false,
    mappings = {
      list = {
        { key = { "<2-RightMouse>" }, action = "" }, -- cd
        { key = "D", action = "" }, -- trash
        { key = "[e", action = "" }, -- prev_diag_item
        { key = "]e", action = "" }, -- next_diag_item
        { key = "[c", action = "" }, -- prev_git_item
        { key = "]c", action = "" }, -- next_git_item
        { key = "g?", action = "" }, -- toggle_help
        { key = "<BS>", action = "" }, -- close_node
        { key = "<C-e>", action = "" }, -- edit_in_place
        { key = "f", action = "" }, -- live_filter
        { key = "F", action = "" }, -- clear_live_filter

        { key = "<C-t>", action = "dir_up" }, -- tabnew
        { key = "O", action = "close_node" }, -- edit_no_picker

        { key = "<Space>t", action = "cd" },
        { key = "<BS>t", action = "cd" },
        { key = "<Space>p", action = "prev_diag_item" },
        { key = "<BS>p", action = "prev_diag_item" },
        { key = "<Space>.", action = "next_diag_item" },
        { key = "<BS>.", action = "next_diag_item" },
        { key = "<Space>k", action = "prev_git_item" },
        { key = "<BS>k", action = "prev_git_item" },
        { key = "<Space>j", action = "next_git_item" },
        { key = "<BS>j", action = "next_git_item" },
        { key = "'", action = "close_node" },
        { key = "?", action = "toggle_help" },
        { key = "<C-P>", action = "print", action_cb = print_node_path },
      },
    },
  },
  renderer = {
    full_name = true,
    group_empty = true,
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
  log = {
    enable = false,
    truncate = true,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },
}

-- maybe find
local function find()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname then
    api.tree.find_file(bufname)
  end
end

--- maybe find and focus
function M.find_focus()
  find()
  api.tree.focus()
end

--- collapse then find
function M.collapse_find()
  api.tree.collapse_all(false)
  find()
end

function M.init()
  tree.setup(config)
end

return M
