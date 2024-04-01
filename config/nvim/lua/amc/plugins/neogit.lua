local M = {}

local windows = require("amc.windows")

local neogit_ok, neogit = pcall(require, "neogit")

if not neogit_ok then
  return
end

local auto = "auto"
---@cast auto WindowKind auto not in enum

local opts = require("neogit.config").get_default_values()

opts.graph_style = "unicode"

opts.disable_insert_on_commit = true

opts.use_per_project_settings = false

opts.remember_settings = false

opts.kind = auto
opts.commit_select_view.kind = auto
opts.log_view.kind = auto
opts.reflog_view.kind = auto

opts.mappings.status["<tab>"] = false
opts.mappings.status["<enter>"] = "Toggle"
opts.mappings.status["o"] = "GoToFile"

opts.mappings.commit_editor["<c-b>"] = "PrevMessage"
opts.mappings.commit_editor["<c-f>"] = "NextMessage"

neogit.setup(opts)

--- no way to remap NeogitLogView mappings, this is the earliest event in which the mappings have been set
--- TODO PR
function M.log_view_cur_moved()
  pcall(vim.keymap.del, "n", ";", { buffer = 0 })
end

function M.open()
  windows.go_home()
  -- TODO focus if open
  neogit.open()
end

return M
