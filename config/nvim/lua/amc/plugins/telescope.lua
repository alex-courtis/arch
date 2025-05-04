local require = require("amc.require").or_nil

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
        attach_mappings = attach_quickfix_select,
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
      scroll_strategy = "limit",
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
          ["<Tab>"] = actions.move_selection_next,
          ["<Down>"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["<S-Tab>"] = actions.move_selection_previous,
          ["<Up>"] = actions.move_selection_previous,

          ["h"] = actions.results_scrolling_left,
          ["l"] = actions.results_scrolling_right,

          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,

          ["<C-u>"] = function(prompt_bufnr)
            action_set.shift_selection(prompt_bufnr, -25)
          end,
          ["<C-d>"] = function(prompt_bufnr)
            action_set.shift_selection(prompt_bufnr, 25)
          end,

          ["H"] = actions.preview_scrolling_left,
          ["L"] = actions.preview_scrolling_right,
          ["K"] = actions.preview_scrolling_up,
          ["J"] = actions.preview_scrolling_down,

          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,

          ["?"] = actions.which_key,
        },
        i = {
          ["<C-c>"] = actions.close,

          ["<CR>"] = actions.select_default,

          ["<Tab>"] = actions.move_selection_next,
          ["<Down>"] = actions.move_selection_next,
          ["<S-Tab>"] = actions.move_selection_previous,
          ["<Up>"] = actions.move_selection_previous,

          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,

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

---extend each builtin to go home and include opts
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
function M.live_grep_hidden(o)
  o = o or {}
  o.vimgrep_arguments = vimgrep_arguments_hidden
  M.live_grep(o)
end

function M.find_files_hidden(o)
  o = o or {}
  o.hidden = true
  M.find_files(o)
end

---grep by filetype
---@param command table as per vim.api.nvim_create_user_command
function M.grep_by_filetype(command)
  M.live_grep({ type_filter = command.args })
end

---grep by buffer filetype
function M.live_grep_filetype_buffer()
  M.live_grep({ type_filter = vim.bo.filetype })
end

---prompt for and grep by filetype
function M.live_grep_filetype_prompt()
  vim.ui.input({ prompt = "filetype: ", completion = "filetype", }, function(filetype)
    if filetype then
      M.live_grep({ type_filter = filetype })
    end
  end)
end

---grep by buffer directory
function M.live_grep_directory_buffer()
  local path = vim.api.nvim_buf_get_name(0)
  local head = vim.fn.fnamemodify(path, ":h")
  M.live_grep({ search_dirs = { head } })
end

---prompt for and grep by directory
function M.live_grep_directory_prompt()
  vim.ui.input({ prompt = "directory: ", completion = "dir", }, function(path)
    if path then
      M.live_grep({ search_dirs = { path } })
    end
  end)
end

M.rhs_n_grep_cword =
":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>"

M.rhs_v_grep =
"\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>"

M.rhs_v_grep_hidden =
"\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep_hidden( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>"

return M
