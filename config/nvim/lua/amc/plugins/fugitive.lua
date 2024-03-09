local M = {}

--- no way to remap fugitive and tpope will not add
function M.attach(data)
  vim.keymap.set("n", "t", "=", { buffer = data.buf, remap = true })
  vim.keymap.set("n", "x", "X", { buffer = data.buf, remap = true })
end

function M.open()
  vim.cmd([[ silent! Git ]])
end

return M
