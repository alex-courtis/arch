local M = {
  -- overridden by dirs.lua
  init_cwd = vim.loop.cwd(),
}

function M.update_path()
  vim.o.path = vim.loop.cwd() .. "/**"
end

function M.update_title()
  vim.o.titlestring = vim.fn.system("printtermtitle")
end

function M.cd_init_cwd()
  vim.cmd.cd(M.init_cwd)
end

return M
