local util = require("amc.util")
local buffers = util.require("amc.buffers")
local env = util.require("amc.env")
local telescope = util.require_or_nil("amc.plugins.telescope")

-- return to initial cwd
vim.api.nvim_create_user_command("CD", function()
  env.cd_init_cwd()
end, {})

-- run vimscript and write output to a new scratch buffer
vim.api.nvim_create_user_command("S", function(cmd)
  buffers.write_scratch(vim.api.nvim_exec(cmd.args, true))
end, { nargs = "+", complete = "expression" })

if telescope then
  vim.api.nvim_create_user_command("RD", function(cmd)
    if telescope.live_grep then
      telescope.live_grep({ search_dirs = cmd.fargs })
    end
  end, { nargs = "+", complete = "dir" })

  vim.api.nvim_create_user_command("RT", function(cmd)
    if telescope.live_grep then
      telescope.live_grep({ type_filter = cmd.args })
    end
  end, { nargs = 1 })
end
