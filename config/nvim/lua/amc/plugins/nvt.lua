local tree = require("nvim-tree")
local api = require("nvim-tree.api")

local lsp_file_operations = require("lsp-file-operations")

local M = {}

local function on_attach(bufnr)
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
  vim.keymap.del('n', 'f',              { buffer = bufnr })
  vim.keymap.del('n', 'F',              { buffer = bufnr })

  vim.keymap.set('n', '<C-t>',    api.tree.change_root_to_parent,     opts('Up'))
  vim.keymap.set('n', 'O',        api.node.navigate.parent_close,     opts('Close Directory'))
  vim.keymap.set('n', '<Space>t', api.tree.change_root_to_node,       opts('CD'))
  vim.keymap.set('n', '<BS>t',    api.tree.change_root_to_node,       opts('CD'))
  vim.keymap.set('n', '<Space>p', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  vim.keymap.set('n', '<BS>p',    api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  vim.keymap.set('n', '<Space>.', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  vim.keymap.set('n', '<BS>.',    api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
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

if vim.env.NVIM_TREE_PROFILE then
  config.log.enable = true
  config.log.types.profile = true
end

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
