local require = require("amc.require_or_nil")

local M = {}

local rainbow = require("rainbow-delimiters")
local rainbow_setup = require("rainbow-delimiters.setup")

if not rainbow or not rainbow_setup then
  return M
end

rainbow_setup.setup({
  strategy = {
    [""] = rainbow.strategy["global"],
  },
  query = {
    [""] = "rainbow-delimiters",
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
