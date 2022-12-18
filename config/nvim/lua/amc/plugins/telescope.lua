local telescope = require("telescope")

local log = require("amc/log")
local actions = require("telescope.actions")
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

function M.buffers()
  builtin.buffers(opts())
end

function M.find_files()
  builtin.find_files(opts())
end

function M.git_status()
  builtin.git_status(opts())
end

function M.grep_string(search)
  local o = opts()

  o.search = search

  builtin.grep_string(o)
end

function M.live_grep()
  builtin.live_grep(opts())
end

function M.lsp_references()
  builtin.live_grep(opts())
end

-- TODO
function M.grep_to_qflist()
  builtin.live_grep({
    on_complete = {
      function(picker)
        vim.api.nvim_create_autocmd("BufLeave", {
          -- buffer = picker.prompt_bufnr,
          group = "PickerInsert",
          nested = true,
          once = true,
          callback = function(data)
            log.line("BufLeave PickerInsert %s", vim.inspect(data))
          end,
        })

        log.line("on_complete %s", vim.inspect(picker.prompt_bufnr))

        -- closes telescope
        actions.send_to_qflist(picker.prompt_bufnr)
      end,
    },
  })
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

return M
