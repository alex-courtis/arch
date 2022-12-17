local telescope = require('telescope')

local M = {}

function M.setup()
  telescope.setup({
    pickers = {
      buffers = {
        ignore_current_buffer = true,
        initial_mode = "normal",
        sort_mru = true,
      },
      git_status = {
        initial_mode = "normal",
      },
      grep_string = {
        initial_mode = "normal",
      },
      lsp_references = {
        initial_mode = "normal",
      },
    },
    defaults = {
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        height = 0.95,
        width = 0.9,
        horizontal = {
          preview_cutoff = 120,
          prompt_position = "top",
        },
        vertical = {
          preview_cutoff = 40,
          prompt_position = "top",
          mirror = true,
        }
      },
    },
  })
end

return M
