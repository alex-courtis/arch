local require = require("amc.require_or_nil")

local M = {}

local telescope = require("telescope")

if not telescope then
  return M
end

local windows = require("amc.windows")

local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local config = require("telescope.config")

telescope.load_extension("smart_history")

local vimgrep_arguments_hidden = vim.deepcopy(config.values.vimgrep_arguments)
table.insert(vimgrep_arguments_hidden, "--hidden")
table.insert(vimgrep_arguments_hidden, "--no-ignore")

local function attach_quickfix_select(prompt_bufnr)
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

local cfg = actions
    and {
      pickers = {
        live_grep = {
          attach_mappings = attach_quickfix_select,
        },
        git_status = {
          initial_mode = "normal",
          path_display = {
            truncate = 3,
          },
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
        diagnostics = {
          attach_mappings = attach_quickfix_select,
          initial_mode = "normal",
        },
      },
      defaults = {
        path_display = {
          truncate = 1,
        },
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
        history = {
          path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
          limit = 100,
        },
        default_mappings = {
          n = {
            ["<ESC>"] = actions.close,
            ["<C-c>"] = actions.close,

            ["<CR>"] = actions.select_default,

            ["j"] = actions.move_selection_next,
            ["<C-n>"] = actions.move_selection_next,
            ["<Tab>"] = actions.move_selection_next,
            ["<Down>"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["<C-p>"] = actions.move_selection_previous,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<Up>"] = actions.move_selection_previous,

            ["h"] = actions.results_scrolling_left,
            ["<C-h>"] = actions.results_scrolling_left,
            ["l"] = actions.results_scrolling_right,
            ["<C-l>"] = actions.results_scrolling_right,

            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<C-j>"] = actions.cycle_history_next,
            ["<C-f>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<C-b>"] = actions.cycle_history_prev,

            ["?"] = actions.which_key,
          },
          i = {
            ["<C-c>"] = actions.close,

            ["<CR>"] = actions.select_default,

            ["<C-n>"] = actions.move_selection_next,
            ["<Tab>"] = actions.move_selection_next,
            ["<Down>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<Up>"] = actions.move_selection_previous,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<C-h>"] = actions.results_scrolling_left,
            ["<C-l>"] = actions.results_scrolling_right,

            ["<C-j>"] = actions.cycle_history_next,
            ["<C-f>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<C-b>"] = actions.cycle_history_prev,

            ["<C-/>"] = actions.which_key,
          },
        },
      },
    }
  or nil

local function opts(o)
  o = o or {}

  if vim.o.columns >= 160 then
    o.layout_strategy = "horizontal"
  else
    o.layout_strategy = "vertical"
  end

  if o.search_dirs then
    o.results_title = table.concat(o.search_dirs, ", ")
  else
    o.results_title = vim.loop.cwd()
  end

  return o
end

--- extend each builtin to go home and include opts
local function extend_builtins()
  for n, f in pairs(builtin) do
    if type(f) == "function" then
      M[n] = function(o)
        if windows then
          windows.go_home()
        end
        return f(opts(o))
      end
    end
  end
end

-- init
telescope.setup(cfg)
extend_builtins()

-- hidden variants
function M.live_grep_hidden()
  M.live_grep({ vimgrep_arguments = vimgrep_arguments_hidden })
end

function M.find_files_hidden()
  M.find_files({ hidden = true })
end

-- grep in directory
vim.api.nvim_create_user_command("RD", function(cmd)
  M.live_grep({ search_dirs = cmd.fargs })
end, { nargs = "+", complete = "dir" })

-- grep by filetype
vim.api.nvim_create_user_command("RT", function(cmd)
  M.live_grep({ type_filter = cmd.args })
end, { nargs = 1 })

return M
