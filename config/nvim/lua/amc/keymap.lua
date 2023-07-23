local M = {}

local MODES = {
  "n",
  "i",
  "c",
  "v",
  "x",
  "s",
  "o",
}

local LEADERS = {
  "<Space>",
  "<BS>",
}

for _, mode in ipairs(MODES) do
  M[mode .. "m" .. "__"] = function(lhs, rhs)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { remap = true })
    end
  end
  M[mode .. "m" .. "s_"] = function(lhs, rhs)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { remap = true, silent = true })
    end
  end
  M[mode .. "m" .. "_l"] = function(lhs, rhs)
    if rhs then
      for _, leader in ipairs(LEADERS) do
        M[mode .. "m" .. "__"](leader .. lhs, rhs)
      end
    end
  end
  M[mode .. "m" .. "sl"] = function(lhs, rhs)
    if rhs then
      for _, leader in ipairs(LEADERS) do
        M[mode .. "m" .. "s_"](leader .. lhs, rhs)
      end
    end
  end
end

return M
