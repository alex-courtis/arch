local require = require("amc.require").or_nil

local outline = require("outline")

if not outline then
  return
end

-- TODO
-- functions and methods only
-- unmap esc
-- map global navigation

outline.setup({
  outline_window = {
    split_command = "above 25split",
  }
})
