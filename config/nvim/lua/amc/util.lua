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
---@param desc string
---@param silent boolean
---@param leader boolean
local function map(mode, lhs, rhs, desc, silent, leader)
  if rhs then
    if leader then
      for _, l in ipairs({ "<Space>", "<BS>" }) do
        vim.keymap.set(mode, l .. lhs, rhs, { desc = desc, remap = false, silent = silent, })
      end
    else
      vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = false, silent = silent, })
    end
  end
end

-- TODO add buffer and move other keymap setters here
M.K = {
  c__ = function(lhs, rhs, desc) map("c", lhs, rhs, desc, false, false) end,

  i__ = function(lhs, rhs, desc) map("i", lhs, rhs, desc, false, false) end,

  n__ = function(lhs, rhs, desc) map("n", lhs, rhs, desc, false, false) end,
  ns_ = function(lhs, rhs, desc) map("n", lhs, rhs, desc, true, false) end,
  n_l = function(lhs, rhs, desc) map("n", lhs, rhs, desc, false, true) end,
  nsl = function(lhs, rhs, desc) map("n", lhs, rhs, desc, true, true) end,

  v__ = function(lhs, rhs, desc) map("v", lhs, rhs, desc, false, false) end,
  vs_ = function(lhs, rhs, desc) map("v", lhs, rhs, desc, true, false) end,
  v_l = function(lhs, rhs, desc) map("v", lhs, rhs, desc, false, true) end,
  vsl = function(lhs, rhs, desc) map("v", lhs, rhs, desc, true, true) end,

  xsl = function(lhs, rhs, desc) map("x", lhs, rhs, desc, true, true) end,
}

return M
