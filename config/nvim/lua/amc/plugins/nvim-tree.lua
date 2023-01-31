local tree = require("nvim-tree")
local api = require("nvim-tree.api")

local lsp_file_operations = require("lsp-file-operations")

local M = {}

local function print_node_path(node)
  print(node.absolute_path)
end

local config = {
  hijack_cursor = true,
  sync_root_with_cwd = true,
  prefer_startup_root = true,
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

--- open and maybe find
function M.open_find()
  api.tree.open({ find_file = true })
end

--- collapse then maybe find
function M.collapse_find()
  local bufname = vim.api.nvim_buf_get_name(0)
  api.tree.collapse_all(false)
  if bufname then
    api.tree.find_file(bufname)
  end
end

function M.open_nvim_tree(data)
  local IGNORED_FT = {
    "gitcommit",
  }

  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup#open-for-files-and-no-name-buffers
  if real_file then
    -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup#open_on_setup_file-and-ignore_ft_on_setup
    -- ignored &filetype
    if vim.tbl_contains(IGNORED_FT, vim.bo[data.buf].ft) then
      return
    end

    -- open the tree but don't focus it
    require("nvim-tree.api").tree.toggle({ focus = false })

    -- find the file if it exists
    require("nvim-tree.api").tree.find_file(data.file)

    return
  end

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup#open-for-directories-and-change-neovims-directory
  if directory then
    -- create a new, empty buffer
    vim.cmd.enew()

    -- wipe the directory buffer
    vim.cmd.bw(data.buf)

    -- change to the directory
    vim.cmd.cd(data.file)

    -- open the tree
    require("nvim-tree.api").tree.open()

    return
  end
end

function M.init()
  tree.setup(config)
  lsp_file_operations.setup({})
end

return M
