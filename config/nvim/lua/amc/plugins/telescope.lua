local M = {}

function M.setup()
  require('telescope').setup({
    pickers = {
      buffers = {
        ignore_current_buffer = true,
        initial_mode = "normal",
        sort_mru = true,
      },
      grep_string = {
        initial_mode = "normal",
      },
      lsp_references = {
        initial_mode = "normal",
      },
    }
  })
end

return M
