local require = require("amc.require_or_nil")

local buffers = require("amc.buffers")

if buffers then
  -- run vimscript and write output to a new scratch buffer
  vim.api.nvim_create_user_command("S", function(cmd)
    local out = vim.api.nvim_exec2(cmd.args, { output = true })
    if out then
      buffers.write_scratch(out.output)
    end
  end, { nargs = "+", complete = "expression" })
end
