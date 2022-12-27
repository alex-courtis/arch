local buffers = require("amc.buffers")
local log = require("amc.log")

local group = vim.api.nvim_create_augroup("amc", { clear = true })

-- unload modules before reloading init
vim.api.nvim_create_autocmd("SourcePre", {
  group = group,
  nested = true,
  callback = function(data)
    if data.file:match("init.lua$") then
      for k, _ in pairs(package.loaded) do
        if (k:match("^amc.") or k == "init") and k ~= "amc.log" then
          log.line("unloading %s", k)
          package.loaded[k] = nil
        end
      end
      log.line("unloading amc.log")
      package.loaded["amc.log"] = nil
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost", "DirChanged", "FocusGained", "VimEnter" }, {
  group = group,
  nested = false,
  callback = function()
    -- rarely update title
    vim.o.titlestring = vim.fn.system("printtermtitle")
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = group,
  nested = true,
  callback = function()
    -- https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
    vim.cmd({ cmd = "cwindow", count = 15 })
  end,
})

vim.api.nvim_create_autocmd("WinClosed", { group = group, nested = false, callback = buffers.WinClosed })
vim.api.nvim_create_autocmd("BufEnter", { group = group, nested = false, callback = buffers.BufEnter })
vim.api.nvim_create_autocmd("FileType", { group = group, nested = false, callback = buffers.FileType })

