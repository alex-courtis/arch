local require = require("amc.require").or_nil

-- local K = require("amc.util").K

local aerial = require("aerial")

if not aerial then
  return
end

aerial.setup({
  layout = {
    default_direction = "left",
  },
  highlight_closest = false,
})

return aerial
