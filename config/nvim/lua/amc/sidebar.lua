local env = require("amc.env")

local M = {}

local require = require("amc.require").or_nil

local nvim_tree_api = require("nvim-tree.api")
local outline = require("amc.plugins.outline")

if not nvim_tree_api or not outline then
  return M
end

local NO_STARTUP_FT = {
  "gitcommit",
  "gitrebase",
}

---create the sidebar with nvim-tree and outline
---returns to current window
---when nvim-tree is closed, outline will be closed and opened
local function sidebar()
  local winid_cur = vim.api.nvim_get_current_win()

  local winid_tree = nvim_tree_api.tree.winid()
  local outline_open = outline.is_open()

  if winid_tree and outline_open then
    return
  end

  if outline_open then
    outline.close()
  end

  if winid_tree then
    nvim_tree_api.tree.focus()
  else
    nvim_tree_api.tree.open()
  end

  outline.open()

  vim.api.nvim_set_current_win(winid_cur)
end

---Focus outline, with a hacky delay of 750 to allow it to initialise from the current buffer
function M.focus_outline()
  if not outline.is_open() then
    sidebar()
    vim.defer_fn(outline.focus_outline, 750)
  else
    outline.focus_outline()
  end
end

---@param opts? nvim_tree.api.tree.open.Opts optional
function M.focus_nvim_tree(opts)
  if not nvim_tree_api.tree.winid() then
    sidebar()
  end
  nvim_tree_api.tree.open(opts)
end

function M.focus_nvim_tree_update_root()
  M.focus_nvim_tree({ update_root = true })
end

---Open sidebar for real files or startup directory
---@param data table from autocommand
function M.vim_enter(data)
  local real_file = vim.fn.filereadable(data.file) == 1

  local temp_file = real_file and data.file:match("^/tmp")

  local ignored_ft = vim.tbl_contains(NO_STARTUP_FT, vim.bo[data.buf].ft)

  if (real_file and not temp_file and not ignored_ft) or env.startup_dir then
    -- schedule as things are event dependent
    vim.schedule(sidebar)
  end
end

return M
