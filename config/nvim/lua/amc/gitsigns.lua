local M = {}

function M.setup()
  require("gitsigns").setup({
    current_line_blame_opts = {
      delay = 100,
    },
  })
end

return M
