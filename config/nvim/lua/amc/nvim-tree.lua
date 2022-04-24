-- g: will eventually move to setup
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_show_icons = { git = 1, folders = 0, files = 1, folder_arrows = 0, }

local tree = require'nvim-tree'
local lib = require'nvim-tree.lib'

tree.setup {
  log = {
    enable = false,
    truncate = true,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      git = false,
    },
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
  },
  open_on_setup = true,
  open_on_setup_file = true,
  actions = {
    change_dir = {
      restrict_above_cwd = true,
    },
    open_file = {
      resize_window = true,
      window_picker = {
        chars = "aoeui",
      }
    }
  },
  filters = {
    custom = {
      "^.git$",
    },
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
  view = {
    mappings = {
      list = {
        { key = {"<2-RightMouse>", "<C-]>"},    action = "" }, -- cd
        { key = "<C-v>",                        action = "" }, -- vsplit
        { key = "<C-x>",                        action = "" }, -- split
        { key = "<C-t>",                        action = "" }, -- tabnew
        { key = "<BS>",                         action = "" }, -- close_node
        { key = "<Tab>",                        action = "" }, -- preview
        { key = "D",                            action = "" }, -- trash
        { key = "[c",                           action = "" }, -- prev_git_item
        { key = "]c",                           action = "" }, -- next_git_item
        { key = "-",                            action = "" }, -- dir_up
        { key = "s",                            action = "" }, -- system_open
        { key = "W",                            action = "" }, -- collapse_all
        { key = "g?",                           action = "" }, -- toggle_help

        { key = "d",                            action = "cd" }, -- remove
        { key = "x",                            action = "remove" }, -- cut

        { key = "t",                            action = "cut" },
        { key = "<Space>k",                     action = "prev_git_item" },
        { key = "<Space>j",                     action = "next_git_item" },
        { key = "u",                            action = "dir_up" },
        { key = "'",                            action = "close_node" },
        { key = "\"",                           action = "collapse_all" },
        { key = "?",                            action = "toggle_help" },
      },
    },
  },
}

