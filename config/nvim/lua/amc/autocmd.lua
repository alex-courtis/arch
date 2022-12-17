local log = require("amc/log")

local group = vim.api.nvim_create_augroup("amc", { clear = true })

-- https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = group,
  nested = true,
  callback = function(data)
    log.line("qf %s", vim.inspect(data))
    vim.cmd({ cmd = "cwindow", count = 15 })
  end,
})

log.line("autocmd done")
