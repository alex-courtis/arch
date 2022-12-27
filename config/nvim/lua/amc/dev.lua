local stylua = require("stylua-nvim")

local M = {}

function M.format()
  local filetype = vim.bo.filetype

  if filetype == "lua" then
    stylua.format_file()
  else
    vim.cmd([[norm! gg=G``]])
  end
end

stylua.setup({
  error_display_strategy = "loclist",
})

return M
