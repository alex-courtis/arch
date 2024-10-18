local env = require("amc.env")

local require = require("amc.require_or_nil")

local buffers = require("amc.buffers") or {}
local dev = require("amc.dev") or {}
local map = require("amc.init.late.map") or {}
local windows = require("amc.windows") or {}
local fugitive = require("amc.plugins.fugitive") or {}
local nvt = require("amc.plugins.nvt") or {}

local group = vim.api.nvim_create_augroup("amc", { clear = true })

local function au(event, callback, opts)
  if callback then
    vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = group, callback = callback }, opts or {}))
  end
end

au({ "BufWritePost", "DirChanged", "FocusGained", "VimEnter" }, env.update_title,            {})
au({ "DirChanged", "VimEnter" },                                env.update_path,             {})
au({ "BufEnter" },                                              buffers.buf_enter,           {})
au({ "WinClosed" },                                             buffers.wipe_unwanted,       {})
au({ "BufLeave", "FocusLost" },                                 buffers.update,              { nested = true })
au({ "QuickFixCmdPost" },                                       windows.open_qf_loc_win,     { nested = true })
au({ "BufWinEnter" },                                           windows.resize_qf_loc_win,   { pattern = { "quickfix" } })
au({ "BufWinEnter" },                                           windows.position_doc_window, {})
au({ "VimResized" },                                            windows.equalise_windows,    {})
au({ "VimEnter" },                                              nvt.vim_enter,               {})
au({ "VimEnter" },                                              map.clear_default_mappings,  {})

au({ "User" },                                                  env.update_title,            { pattern = { "FugitiveChanged" } })

au({ "FileType" },                                              fugitive.attach,             { pattern = { "fugitive" } })
au({ "FileType" },                                              dev.ft_lua,                  { pattern = { "lua" } })
au({ "FileType" },                                              dev.ft_c,                    { pattern = { "c", "cpp" } })
au({ "FileType" },                                              buffers.default_modeline,    { pattern = { "lua", "json", "yml", "yaml", "ts", "tf" } })
