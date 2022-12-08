local M = {}

function M.setup()
  require('telescope').setup({})
  require('telescope').load_extension('fzf')
end

return M
