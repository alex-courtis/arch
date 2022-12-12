local M = {}

function M.setup()
  require('telescope').setup({
    pickers = {
      buffers = {
        initial_mode = "normal",
      },
    }
  })
end

return M
