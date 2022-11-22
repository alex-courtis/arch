local M = {}

function M.setup()
  local tree = require("nvim-tree")

  local function print_node_path(node)
    print(node.absolute_path)
  end

  tree.setup({
    create_in_closed_folder = true,
    hijack_cursor = true,
    open_on_setup = true,
    open_on_setup_file = true,
    sync_root_with_cwd = true,
    ignore_ft_on_setup = {
      "gitcommit",
    },
    view = {
      adaptive_size = false,
      mappings = {
        list = {
          { key = { "<2-RightMouse>", "<C-]>" }, action = "" }, -- cd
          { key = "D", action = "" }, -- trash
          { key = "[e", action = "" }, -- prev_diag_item
          { key = "]e", action = "" }, -- next_diag_item
          { key = "[c", action = "" }, -- prev_git_item
          { key = "]c", action = "" }, -- next_git_item
          { key = "g?", action = "" }, -- toggle_help

          { key = "<C-t>", action = "dir_up" }, -- tabnew

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
      },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
      ignore_list = { "help" },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
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
    actions = {
      change_dir = {
        enable = false,
        restrict_above_cwd = true,
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
  })
end

return M
