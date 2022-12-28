local buffers = require("amc.buffers")

-- run vimscript and write output to a new scratch buffer
vim.api.nvim_create_user_command("S", function(cmd)
  buffers.write_scratch(vim.api.nvim_exec(cmd.args, true))
end, { nargs = "+", complete = "expression" })
