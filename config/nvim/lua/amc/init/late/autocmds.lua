local env = require("amc.env")
local util = require("amc.util")

local require = require("amc.require_or_nil")

local buffers = require("amc.buffers") or {}
local windows = require("amc.windows") or {}
local fugitive = require("amc.plugins.fugitive") or {}
local nvt = require("amc.plugins.nvt") or {}

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
au({ "BufEnter" },                                              util.reset_mappings,          {})
au({ "BufEnter" },                                              buffers.wipe_alt_no_name_new, {})
au({ "BufDelete", "BufWipeout" },                               buffers.purge_whitespace_data,{})
au({ "WinClosed" },                                             buffers.wipe_unwanted,        {})
au({ "BufLeave", "FocusLost" },                                 buffers.update,               { nested = true })
au({ "QuickFixCmdPost" },                                       windows.open_qf_loc_win,      { nested = true })
au({ "BufWinEnter" },                                           windows.resize_qf_loc_win,    { pattern = { "quickfix" } })
au({ "BufWinEnter" },                                           windows.position_doc_window,  {})
au({ "VimEnter" },                                              nvt.vim_enter,                {})

ft({ "fugitive" },                                              fugitive.attach,              {})
-- stylua: ignore end

-- v/h resize windows on terminal size change
au({ "VimResized" }, function()
  vim.cmd.wincmd("=")
end)

-- man is not useful, vim help usually is
ft({ "lua" }, function(data)
  vim.api.nvim_set_option_value("keywordprg", ":help", { buf = data.buf })
end)

-- line comments please
ft({ "c", "cpp" }, function(data)
  vim.api.nvim_set_option_value("commentstring", "// %s", { buf = data.buf })
end)

-- keep these roughly in sync with ~/.editorconfig, which will not be found outside of ~
ft({ "lua", "json", "yml", "yaml", "ts", "tf" }, function(data)
  vim.bo[data.buf].expandtab = true
  vim.bo[data.buf].shiftwidth = 2
  vim.bo[data.buf].softtabstop = 2
  vim.bo[data.buf].tabstop = 2
end)
