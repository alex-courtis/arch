local tree = require'nvim-tree'
local config = require'nvim-tree.config'

-- g: will eventually move to setup
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_refresh_wait = 500
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_symlink_arrow = ' -> '
vim.g.nvim_tree_window_picker_chars = "aoeu"
vim.g.nvim_tree_window_picker_exclude = {
	filetype = {
		'diff',
		'notify',
		'packer',
		'fugitive',
		'fugitiveblame',
	},
	buftype = {
		'help',
		'quickfix',
		'nofile',
		'terminal',
	}
}

local tree_cb = config.nvim_tree_callback
tree.setup {
	hijack_cursor = true,
	update_cwd = true,
	update_to_buf_dir = {
		enable = false,
		auto_open = false,
	},
	update_focused_file = {
		enable = true,
	},
	view = {
		mappings = {
			list = {
				{ key = "<BS>", cb = nil },
				{ key = "<Space>j", cb = tree_cb("next_git_item") },
				{ key = "<Space>k", cb = tree_cb("prev_git_item") }
			}
		},
	},
}

