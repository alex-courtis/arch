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

--- au FileType
function M.FileType(data)

  -- man is not useful, vim help usually is
  if data.match == "lua" then
    vim.api.nvim_buf_set_option(data.buf, "keywordprg", ":help")
  end

  -- line comments please
  if data.match == "c" or data.match == "cpp" then
    vim.api.nvim_buf_set_option(data.buf, "commentstring", "// %s")
  end
end

return M
