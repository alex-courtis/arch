local tree = require'nvim-tree'
local lib = require'nvim-tree.lib'

-- g: will eventually move to setup
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_special_files = {}
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


local function cd_dot_cb(node)
	local global_cwd = vim.fn.getcwd(-1)
	tree.change_dir(global_cwd)
	return lib.set_index_and_redraw(node.absolute_path)
end

tree.setup {
	-- https://github.com/kyazdani42/nvim-tree.lua/issues/972
	-- hijack_cursor = true,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	open_on_setup = true,
	view = {
		mappings = {
			list = {
				{ key = {"<2-RightMouse>", "<C-]>"},    action = "" },
				{ key = "<C-v>",                        action = "" },
				{ key = "<C-x>",                        action = "" },
				{ key = "<C-t>",                        action = "" },
				{ key = "<BS>",                         action = "" },
				{ key = "<Tab>",                        action = "" },
				{ key = "D",                            action = "" },
				{ key = "[c",                           action = "" },
				{ key = "]c",                           action = "" },
				{ key = "-",                            action = "" },
				{ key = "s",                            action = "" },

				{ key = "d",                            action = "cd" },
				{ key = "O",                            action = "close_node" },
				{ key = "x",                            action = "remove" },
				{ key = "t",                            action = "cut" },

				{ key = "<Space>k",                     action = "prev_git_item" },
				{ key = "<Space>j",                     action = "next_git_item" },
				{ key = "u",                            action = "dir_up" },

				{ key = ".",                            action = "cd_dot",		action_cb = cd_dot_cb, },
			},
		},
	},
}

