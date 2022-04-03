-- g: will eventually move to setup
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_show_icons = { git = 1, folders = 0, files = 1, folder_arrows = 0, }
vim.g.nvim_tree_indent_markers = 1

local tree = require'nvim-tree'
local lib = require'nvim-tree.lib'

local function cd_dot_cb(node)
  tree.change_dir(vim.fn.getcwd(-1))
  if node.name ~= ".." then
    lib.set_index_and_redraw(node.absolute_path)
  end
end

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
    open_file = {
      resize_window = true,
      window_picker = {
        chars = "aoeui",
      }
    }
  },
  filters = {
    custom = {
      ".git",
    },
  },
  view = {
    indent_markers = {
      enable = true,
    },
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
        { key = "R",                            action = "" }, -- refresh
        { key = "g?",                           action = "" }, -- toggle_help

        { key = "d",                            action = "cd" }, -- remove
        { key = "x",                            action = "remove" }, -- cut

        { key = "t",                            action = "cut" },
        { key = "<Space>k",                     action = "prev_git_item" },
        { key = "<Space>j",                     action = "next_git_item" },
        { key = "u",                            action = "dir_up" },
        { key = "f",                            action = "run_file_command" },
        { key = "'",                            action = "close_node" },
        { key = "\"",                           action = "collapse_all" },
        { key = "A",                            action = "refresh" },
        { key = "?",                            action = "toggle_help" },

        { key = ".",                            action = "cd_dot",		action_cb = cd_dot_cb, }, -- run_file_command
      },
    },
  },
}

