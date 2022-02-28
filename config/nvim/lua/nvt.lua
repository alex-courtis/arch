-- g: will eventually move to setup
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_show_icons = { git = 1, folders = 0, files = 1, folder_arrows = 0, }

local tree = require'nvim-tree'
local lib = require'nvim-tree.lib'

local function cd_dot_cb(node)
	local global_cwd = vim.fn.getcwd(-1)
	tree.change_dir(global_cwd)
	return lib.set_index_and_redraw(node.absolute_path)
end

tree.setup {
	update_cwd = true,
	update_focused_file = {
		enable = true,
	},
	open_on_setup = true,
	actions = {
		open_file = {
			window_picker = {
				chars = "aoeui",
				-- waiting on https://github.com/kyazdani42/nvim-tree.lua/pull/1027
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", },
					buftype  = { "nofile", "terminal", "help", },
				}
			}
		}
	},
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

