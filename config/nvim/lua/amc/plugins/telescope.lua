local telescope = require("telescope")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local M = {
  last_grep = nil,
}

local function opts()
  local o = {}

  if vim.o.columns >= 160 then
    o.layout_strategy = "horizontal"
  else
    o.layout_strategy = "vertical"
  end

  return o
end

local function attach_quickfix_select(prompt_bufnr)
  actions.select_default:replace(function()
    local picker = action_state.get_current_picker(prompt_bufnr)
    local manager = picker.manager

    if manager:num_results() > 0 then
      -- quickfix handles results
      local count = picker:get_selection_row() + 1

      -- closes telescope
      actions.send_to_qflist(prompt_bufnr)

      vim.cmd({ cmd = "cwindow", count = 15 })
      vim.cmd({ cmd = "cc", count = count })

      return true
    else
      -- telescope default
      return action_set.edit(prompt_bufnr, "default")
    end
  end)
  return true
end

local function set_last_grep()
  M.last_grep = action_state.get_current_line()
end

telescope.setup({
  pickers = {
    live_grep = {
      attach_mappings = attach_quickfix_select,
      on_complete = {
        set_last_grep,
      },
    },
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
      if o and o.default_text then
        M.last_grep = o.default_text
      end
      return f(vim.tbl_extend("force", opts(), o or {}))
    end
  end
end

function M.live_grep_last(o)
  o = vim.tbl_extend("force", opts(), o or {})

  o.default_text = M.last_grep

  return builtin.live_grep(o)
end

return M
