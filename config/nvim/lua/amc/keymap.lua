local M = {}

MODES = {
  "n",
  "i",
  "c",
  "v",
  "x",
  "s",
  "o",
}

LEADERS = {
  "<Space>",
  "<BS>",
}

for _, mode in ipairs(MODES) do
  M[mode .. "m" .. "__"] = function(lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { remap = true })
  end
  M[mode .. "m" .. "s_"] = function(lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { remap = true, silent = true })
  end
  M[mode .. "m" .. "_l"] = function(lhs, rhs)
    for _, leader in ipairs(LEADERS) do
      M[mode .. "m" .. "__"](leader .. lhs, rhs)
    end
  end
  M[mode .. "m" .. "sl"] = function(lhs, rhs)
    for _, leader in ipairs(LEADERS) do
      M[mode .. "m" .. "s_"](leader .. lhs, rhs)
    end
  end
end

return M
