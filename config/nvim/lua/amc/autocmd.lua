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

-- https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = group,
  nested = true,
  callback = function()
    vim.cmd({ cmd = "cwindow", count = 15 })
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  group = group,
  nested = false,
  callback = function(data)
    -- wipe unwanted buffers
    buffers.wipe_unwanted(data)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  nested = false,
  callback = function(data)
    -- no name new buffers are not wiped when loading an existing buffer over them
    buffers.wipe_alt_no_name_new(data)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  nested = false,
  callback = function(data)
    if data.match == "lua" then
      -- man is not useful, vim help usually is
      vim.api.nvim_buf_set_option(data.buf, "keywordprg", ":help")
    end
  end,
})
