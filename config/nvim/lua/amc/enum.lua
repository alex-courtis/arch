local M = {}

---@enum SPECIAL
M.SPECIAL = {
  help = 1,
  quick_fix = 2,
  man = 3,
  fugitive = 4,
  nvim_tree = 5,
  aerial = 6,
  dir = 7,
  other = 8,
}

---@enum CLOSE_INC
M.CLOSE_INC = {
  [M.SPECIAL.quick_fix] = 1,
  [M.SPECIAL.fugitive] = 2,
  [M.SPECIAL.help] = 3,
  [M.SPECIAL.aerial] = 4,
  [M.SPECIAL.nvim_tree] = 5,
}

---@enum BUILD_TYPE
M.BUILD_TYPE = {
  make = 0,
  meson = 1,
}

return M
