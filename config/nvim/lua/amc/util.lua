local M = {}

---Read .nvt-dir and return first path containing /lua/nvim-tree.lua
---@return string dir from file otherwise "nvim-tree/nvim-tree.lua"
function M.nvt_plugin_dir()
  local config_file_path = vim.env.HOME .. "/.nvt-dir"
  if vim.loop.fs_stat(config_file_path) then
    for nvt_dir in io.lines(config_file_path) do
      if vim.loop.fs_stat(nvt_dir .. "/lua/nvim-tree.lua") then
        return nvt_dir
      end
    end
  end
  return "nvim-tree/nvim-tree.lua"
end

---@param mode string
---@param lhs string
---@param rhs function|string
---@param opts vim.keymap.set.Opts
local function map_(mode, lhs, rhs, opts)
  if rhs then
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

---@param mode string
---@param lhs string
---@param rhs function|string
---@param opts vim.keymap.set.Opts
local function mapl(mode, lhs, rhs, opts)
  if rhs then
    for _, l in ipairs({ "<Space>", "<BS>" }) do
      vim.keymap.set(mode, l .. lhs, rhs, opts)
    end
  end
end

-- lua /home/alex/.dotfiles/config/nvim/lua/amc/gen-util.K.lua | wl-copy
M.K = {
  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  n__ = function(lhs, rhs, desc, opts) map_("n", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  ns_ = function(lhs, rhs, desc, opts) map_("n", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  n_l = function(lhs, rhs, desc, opts) mapl("n", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  nsl = function(lhs, rhs, desc, opts) mapl("n", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  i__ = function(lhs, rhs, desc, opts) map_("i", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  is_ = function(lhs, rhs, desc, opts) map_("i", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  i_l = function(lhs, rhs, desc, opts) mapl("i", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  isl = function(lhs, rhs, desc, opts) mapl("i", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  c__ = function(lhs, rhs, desc, opts) map_("c", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  cs_ = function(lhs, rhs, desc, opts) map_("c", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  c_l = function(lhs, rhs, desc, opts) mapl("c", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  csl = function(lhs, rhs, desc, opts) mapl("c", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  v__ = function(lhs, rhs, desc, opts) map_("v", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  vs_ = function(lhs, rhs, desc, opts) map_("v", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  v_l = function(lhs, rhs, desc, opts) mapl("v", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  vsl = function(lhs, rhs, desc, opts) mapl("v", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  x__ = function(lhs, rhs, desc, opts) map_("x", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  xs_ = function(lhs, rhs, desc, opts) map_("x", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  x_l = function(lhs, rhs, desc, opts) mapl("x", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  xsl = function(lhs, rhs, desc, opts) mapl("x", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  s__ = function(lhs, rhs, desc, opts) map_("s", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  ss_ = function(lhs, rhs, desc, opts) map_("s", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  s_l = function(lhs, rhs, desc, opts) mapl("s", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  ssl = function(lhs, rhs, desc, opts) mapl("s", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  o__ = function(lhs, rhs, desc, opts) map_("o", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  os_ = function(lhs, rhs, desc, opts) map_("o", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  o_l = function(lhs, rhs, desc, opts) mapl("o", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = false, })) end,

  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  osl = function(lhs, rhs, desc, opts) mapl("o", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = true, })) end,
}

return M
