local telescope = require("telescope")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local M = {}

-- builtin's last search text
local last = {
  live_grep = "",
  find_files = "",
  git_status = "",
}

local function attach_quickfix_select(prompt_bufnr)
  actions.select_default:replace(function()
    local picker = action_state.get_current_picker(prompt_bufnr)
    local manager = picker.manager

    if manager:num_results() > 0 then
      -- quickfix handles results
      local count = picker:get_selection_row() + 1

      -- closes telescope
      actions.send_to_qflist(prompt_bufnr)

      vim.cmd("cwindow")
      vim.cmd({ cmd = "cc", count = count })

      return true
    else
      -- telescope default
      return action_set.edit(prompt_bufnr, "default")
    end
  end)
  return true
end

local telescope_opts = {
  pickers = {
    live_grep = {
      attach_mappings = attach_quickfix_select,
    },
    buffers = {
      ignore_current_buffer = true,
      initial_mode = "normal",
      sort_mru = true,
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

for n, _ in pairs(last) do
  -- run builtin with last text populated
  M[n .. "_last"] = function(o)
    o = o or {}
    o.default_text = last[n]
    o.initial_mode = "normal"
    return M[n](o)
  end

  -- set last text
  telescope_opts.pickers[n] = telescope_opts.pickers[n] or {}
  telescope_opts.pickers[n].on_complete = {
    function()
      last[n] = action_state.get_current_line()
    end,
  }
end

telescope.setup(telescope_opts)

-- extend each builtin to include opts
for n, f in pairs(builtin) do
  if type(f) == "function" then
    M[n] = function(o)
      return f(vim.tbl_extend("force", opts(), o or {}))
    end
  end
end

return M
