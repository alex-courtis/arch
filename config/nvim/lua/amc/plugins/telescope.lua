local telescope = require("telescope")
local builtin = require("telescope.builtin")

local M = {}

local function opts()
  local o = {}

  if vim.o.columns >= 160 then
    o.layout_strategy = "horizontal"
  else
    o.layout_strategy = "vertical"
  end

  return o
end

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
        preview_cutoff = 160,
        prompt_position = "top",
      },
      vertical = {
        preview_cutoff = 55,
        prompt_position = "top",
        mirror = true,
      },
    },
  },
})

for n, f in pairs(builtin) do
  if type(f) == "function" then
    M[n] = function(o)
      return f(vim.tbl_extend("force", opts(), o or {}))
    end
  end
end

return M
