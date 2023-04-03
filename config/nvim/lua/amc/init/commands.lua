local buffers = require("amc.buffers")
local telescope = require("amc.plugins.telescope")

-- run vimscript and write output to a new scratch buffer
vim.api.nvim_create_user_command("S", function(cmd)
  buffers.write_scratch(vim.api.nvim_exec(cmd.args, true))
end, { nargs = "+", complete = "expression" })

vim.api.nvim_create_user_command("RD", function(cmd)
  print(vim.inspect(cmd))
  telescope.live_grep({ search_dirs = cmd.fargs})
end, { nargs = "+", complete = "dir" })

vim.api.nvim_create_user_command("RT", function(cmd)
  print(vim.inspect(cmd))
  telescope.live_grep({ type_filter = cmd.args})
end, { nargs = 1, })
