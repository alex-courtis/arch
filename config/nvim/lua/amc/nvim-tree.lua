local M = {}

function M.setup()
  local tree = require("nvim-tree")

  tree.setup({
    create_in_closed_folder = true,
    hijack_cursor = true, -- TODO apparently not working
    open_on_setup_file = true,
    reload_on_bufenter = true,
    update_cwd = true,
    renderer = {
      group_empty = true,
      special_files = {},
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
      },
    },
    update_focused_file = {
      enable = true,
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
    },
    filters = {
      custom = {
        "^.git$",
      },
    },
    actions = {
      change_dir = {
        restrict_above_cwd = true,
      },
      open_file = {
        resize_window = true,
        window_picker = {
          chars = "aoeui",
        },
      },
    },
    view = {
      mappings = {
        list = {
          { key = { "<2-RightMouse>", "<C-]>" }, action = "" }, -- cd
          { key = "<C-v>", action = "" }, -- vsplit
          { key = "<C-x>", action = "" }, -- split
          { key = "<C-t>", action = "" }, -- tabnew
          { key = "<BS>", action = "" }, -- close_node
          { key = "<Tab>", action = "" }, -- preview
          { key = "D", action = "" }, -- trash
          { key = "[c", action = "" }, -- prev_git_item
          { key = "]c", action = "" }, -- next_git_item
          { key = "-", action = "" }, -- dir_up
          { key = "s", action = "" }, -- system_open
          { key = "W", action = "" }, -- collapse_all
          { key = "g?", action = "" }, -- toggle_help

          { key = "d", action = "cd" }, -- remove
          { key = "x", action = "remove" }, -- cut

          { key = "t", action = "cut" },
          { key = "<Space>k", action = "prev_git_item" },
          { key = "<Space>j", action = "next_git_item" },
          { key = "u", action = "dir_up" },
          { key = "'", action = "close_node" },
          { key = '"', action = "collapse_all" },
          { key = "?", action = "toggle_help" },
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
        git = false,
      },
    },
  })
end

return M

