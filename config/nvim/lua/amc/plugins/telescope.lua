local util = require("amc.util")
local windows = require("amc.windows")

local telescope = util.require_or_nil("telescope")
local actions = util.require_or_nil("telescope.actions")
local action_set = util.require_or_nil("telescope.actions.set")
local action_state = util.require_or_nil("telescope.actions.state")
local builtin = util.require_or_nil("telescope.builtin")

local M = {}

-- builtin's last search text
local last = {
  live_grep = "",
  find_files = "",
  git_status = "",
}

local function attach_quickfix_select(prompt_bufnr)
  if not actions or not action_set or not action_state then
    return false
  end

  actions.select_default:replace(function()
    local picker = action_state.get_current_picker(prompt_bufnr)
    local manager = picker.manager

    if manager:num_results() > 0 then
      -- quickfix handles results
      local count = picker:get_selection_row() + 1

      -- closes telescope
      actions.send_to_qflist(prompt_bufnr)

      vim.cmd.cwindow()
      vim.cmd.cc({ count = count })

      return true
    else
      -- telescope default
      return action_set.edit(prompt_bufnr, "default")
    end
  end)
  return true
end

local config = actions
    and {
      pickers = {
        live_grep = {
          attach_mappings = attach_quickfix_select,
        },
        git_status = {
          initial_mode = "normal",
        },
        buffers = {
          ignore_current_buffer = true,
          initial_mode = "normal",
          sort_mru = true,
          mappings = {
            n = {
              ["d"] = actions.delete_buffer,
            },
          },
        },
        lsp_references = {
          attach_mappings = attach_quickfix_select,
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
        mappings = {
          n = {
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<Tab>"] = actions.move_selection_next,
            ["<M-q>"] = false,
            ["<PageDown>"] = false,
            ["<PageUp>"] = false,
            ["H"] = false,
            ["L"] = false,
            ["M"] = false,
          },
          i = {
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<Tab>"] = actions.move_selection_next,
            ["<C-l>"] = false,
            ["<M-q>"] = false,
            ["<PageDown>"] = false,
            ["<PageUp>"] = false,
          },
        },
      },
    }
  or nil

local function opts()
  local o = {}

  if vim.o.columns >= 160 then
    o.layout_strategy = "horizontal"
  else
    o.layout_strategy = "vertical"
  end

  return o
end

--- run builtin with last text populated
local function add_builtins()
  if not config or not action_state then
    return
  end

  for n, _ in pairs(last) do
    M[n .. "_last"] = function(o)
      o = o or {}
      o.default_text = last[n]
      o.initial_mode = "normal"
      return M[n](o)
    end

    -- set last text
    config.pickers[n] = config.pickers[n] or {}
    config.pickers[n].on_complete = {
      function()
        last[n] = action_state.get_current_line()
      end,
    }
  end
end

--- extend each builtin to go home and include opts
local function extend_builtins()
  if not builtin then
    return
  end

  for n, f in pairs(builtin) do
    if type(f) == "function" then
      M[n] = function(o)
        windows.go_home()
        return f(vim.tbl_extend("force", opts(), o or {}))
      end
    end
  end
end

function M.init()
  if not telescope or not actions or not action_set or not action_state or not builtin then
    return
  end

  add_builtins()

  telescope.setup(config)

  extend_builtins()
end

return M
