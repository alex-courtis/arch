local tree = require'nvim-tree'
local lib = require'nvim-tree.lib'
local actions = require'nvim-tree.actions'

-- g: will eventually move to setup
vim.g.nvim_tree_change_dir_global = 0
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_indent_markers = 1
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
vim.g.nvim_tree_icons = {
	default      = ' ',
	symlink      = ' ',
	folder = {
		arrow_open   = "",
		arrow_closed = "",
		default      = "",
		open         = "",
		empty        = "",
		empty_open   = "",
		symlink      = "",
		symlink_open = "",
	},
}

local function cd_dot_cb(node)
	local global_cwd = vim.fn.getcwd(-1)
	tree.change_dir(global_cwd)
	return lib.set_index_and_redraw(node.absolute_path)
end

tree.setup {
	hijack_unnamed_buffer_when_opening = false,
	-- https://github.com/kyazdani42/nvim-tree.lua/issues/972
	-- hijack_cursor = true,
	update_cwd = true,
	update_to_buf_dir = {
		enable = false,
		auto_open = false,
	},
	update_focused_file = {
		enable = true,
	},
	open_on_setup = true,
	view = {
		mappings = {
			custom_only = true,
			list = {
				{ key = {"<CR>", "o", "<2-LeftMouse>"}, action = "edit" },
				{ key = "<",                            action = "prev_sibling" },
				{ key = ">",                            action = "next_sibling" },
				{ key = "P",                            action = "parent_node" },
				{ key = "K",                            action = "first_sibling" },
				{ key = "J",                            action = "last_sibling" },
				{ key = "I",                            action = "toggle_ignored" },
				{ key = "H",                            action = "toggle_dotfiles" },
				{ key = "R",                            action = "refresh" },
				{ key = "a",                            action = "create" },
				{ key = "r",                            action = "rename" },
				{ key = "<C-r>",                        action = "full_rename" },
				{ key = "c",                            action = "copy"},
				{ key = "p",                            action = "paste" },
				{ key = "y",                            action = "copy_name" },
				{ key = "Y",                            action = "copy_path" },
				{ key = "gy",                           action = "copy_absolute_path" },
				{ key = "q",                            action = "close"},
				{ key = "g?",                           action = "toggle_help" },

				{ key = "d",                            action = "cd" },
				{ key = "O",                            action = "close_node" },
				{ key = "x",                            action = "remove" },
				{ key = "t",                            action = "cut" },
				{ key = "<Space>k",                     action = "prev_git_item" },
				{ key = "<Space>j",                     action = "next_git_item" },
				{ key = "u",                            action = "dir_up" },

				{ key = ".",                            action = "cd_dot" },
			},
		},
	},
}

-- https://github.com/kyazdani42/nvim-tree.lua/issues/973
actions.custom_keypress_funcs = {
	cd_dot = cd_dot_cb,
}

