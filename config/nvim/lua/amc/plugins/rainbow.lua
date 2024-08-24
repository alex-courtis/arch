local M = {}

local rainbow_ok, rainbow = pcall(require, "rainbow-delimiters")
if not rainbow_ok then
  return M
end
local rainbow_setup = require("rainbow-delimiters.setup")

rainbow_setup.setup({
  strategy = {
    [''] = rainbow.strategy['global'],
  },
  query = {
    [''] = 'rainbow-delimiters',
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
})

function M.toggle()
  rainbow.toggle(0)
end

return M
