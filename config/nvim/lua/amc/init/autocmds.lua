local buffers = require("amc.buffers")
local dev = require("amc.dev")
local env = require("amc.env")
local windows = require("amc.windows")

local group = vim.api.nvim_create_augroup("amc", { clear = true })

-- unload modules before reloading
vim.api.nvim_create_autocmd({ "SourcePre"}, { group = group, callback = env.unload })

-- env
vim.api.nvim_create_autocmd({ "BufWritePost", "DirChanged", "FocusGained", "VimEnter" }, { group = group, callback = env.update_title })
vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, { group = group, callback = env.update_path })

-- buffer
vim.api.nvim_create_autocmd({ "BufEnter" }, { group = group, callback = buffers.BufEnter })
vim.api.nvim_create_autocmd({ "WinClosed" }, { group = group, callback = buffers.WinClosed })
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, { group = group, callback = buffers.update, nested = true, })

-- dev
vim.api.nvim_create_autocmd({ "FileType" }, { group = group, callback = dev.FileType })

-- window
vim.api.nvim_create_autocmd({ "BufWinEnter" }, { group = group, callback = windows.BufWinEnter })
vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, { group = group, nested = true, callback = windows.QuickFixCmdPost })
