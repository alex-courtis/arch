local M = {}

---@enum SPECIAL
M.SPECIAL = {
  help = 1,
  quick_fix = 2,
  man = 3,
  fugitive = 4,
  nvim_tree = 5,
  dir = 6,
  other = 7,
}

---@enum CLOSE_INC
M.CLOSE_INC = {
  [M.SPECIAL.quick_fix] = 1,
  [M.SPECIAL.fugitive] = 2,
  [M.SPECIAL.help] = 3,
  [M.SPECIAL.nvim_tree] = 4,
}

return M
