local buffers = require("amc.buffers")
local env = require("amc.env")
local windows = require("amc.windows")
local nvim_tree_amc = require("amc.plugins.nvt")

local group = vim.api.nvim_create_augroup("amc", { clear = true })

local function au(event, callback, opts)
  if callback then
    vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = group, callback = callback }, opts or {}))
  end
end

local function ft(pattern, callback, opts)
  if callback then
    vim.api.nvim_create_autocmd("FileType", vim.tbl_extend("force", { group = group, callback = callback, pattern = pattern }, opts or {}))
  end
end

-- stylua: ignore start
au({ "BufWritePost", "DirChanged", "FocusGained", "VimEnter" }, env.update_title,             {})
au({ "DirChanged", "VimEnter" },                                env.update_path,              {})
au({ "BufEnter" },                                              buffers.wipe_alt_no_name_new, {})
au({ "WinClosed" },                                             buffers.wipe_unwanted,        {})
au({ "BufLeave", "FocusLost" },                                 buffers.update,               { nested = true })
au({ "QuickFixCmdPost" },                                       windows.open_qf_loc_win,      { nested = true })
au({ "BufWinEnter" },                                           windows.resize_qf_loc_win,    { pattern = { "quickfix" } })
au({ "VimEnter" },                                              nvim_tree_amc.vim_enter,          {})
-- stylua: ignore end

-- v/h resize windows on terminal size change
au({ "VimResized" }, function()
  vim.cmd.wincmd("=")
end)

--- no way to remap fugitive and tpope will not add
ft({ "fugitive" }, function(data)
  vim.keymap.set("n", "t", "=", { buffer = data.buf, remap = true })
  vim.keymap.set("n", "x", "X", { buffer = data.buf, remap = true })
end)

-- man is not useful, vim help usually is
ft({ "lua" }, function(data)
  vim.api.nvim_buf_set_option(data.buf, "keywordprg", ":help")
end)

-- line comments please
ft({ "c", "cpp" }, function(data)
  vim.api.nvim_buf_set_option(data.buf, "commentstring", "// %s")
end)

-- keep these roughly in sync with ~/.editorconfig, which will not be found outside of ~
ft({ "lua", "json", "yml", "yaml", "ts", "tf" }, function(data)
  vim.bo[data.buf].expandtab = true
  vim.bo[data.buf].shiftwidth = 2
  vim.bo[data.buf].softtabstop = 2
  vim.bo[data.buf].tabstop = 2
end)
