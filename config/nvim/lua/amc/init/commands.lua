local buffers = require("amc.buffers")
local env = require("amc.env")
local telescope_amc = require("amc.plugins.telescope")

-- return to initial cwd
vim.api.nvim_create_user_command("CD", function()
  env.cd_init_cwd()
end, {})

-- run vimscript and write output to a new scratch buffer
vim.api.nvim_create_user_command("S", function(cmd)
  buffers.write_scratch(vim.api.nvim_exec(cmd.args, true))
end, { nargs = "+", complete = "expression" })

if telescope_amc then
  vim.api.nvim_create_user_command("RD", function(cmd)
    if telescope_amc.live_grep then
      telescope_amc.live_grep({ search_dirs = cmd.fargs })
    end
  end, { nargs = "+", complete = "dir" })

  vim.api.nvim_create_user_command("RT", function(cmd)
    if telescope_amc.live_grep then
      telescope_amc.live_grep({ type_filter = cmd.args })
    end
  end, { nargs = 1 })
end
