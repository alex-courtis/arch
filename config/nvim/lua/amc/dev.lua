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

function M.source()
  local filetype = vim.bo.filetype
  if filetype == "lua" or filetype == "vim" then
    vim.cmd.so()
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

  -- no way to remap fugitive and tpope will not add
  if data.match == "fugitive" then
    vim.keymap.set("n", "t", "=", { buffer = data.buf, remap = true })
    vim.keymap.set("n", "x", "X", { buffer = data.buf, remap = true })
  end
end

return M
