local M = {}

function M.update_path()
  vim.o.path = vim.loop.cwd() .. "/**"
end

function M.update_title()
  vim.o.titlestring = vim.fn.system("printtermtitle")
end

return M
