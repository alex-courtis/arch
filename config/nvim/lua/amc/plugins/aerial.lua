local windows = require("amc.windows")

local require = require("amc.require").or_nil

local aerial = require("aerial")

if not aerial then
  return
end

aerial.setup({
  layout = {
    resize_to_content = false,
  },
  highlight_closest = false,
})

function aerial.home_focus()
  windows.go_home()
  aerial.focus()
end

return aerial
