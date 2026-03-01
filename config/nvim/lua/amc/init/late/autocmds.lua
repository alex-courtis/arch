local env = require("amc.env")

local require = require("amc.require").or_empty

local buffers = require("amc.buffers")
local sidebar = require("amc.sidebar")
local dev = require("amc.dev")
local windows = require("amc.windows")
local fugitive = require("amc.plugins.fugitive")

local group = vim.api.nvim_create_augroup("amc", { clear = true })

local function au(event, callback, opts)
  if callback then
    vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = group, callback = callback }, opts or {}))
  end
end

au({ "BufWritePost", "DirChanged", "FocusGained", "VimEnter" }, env.update_title,         {})
au({ "DirChanged", "VimEnter" },                                env.update_path,          {})
au({ "BufEnter" },                                              buffers.wipe_no_name_new, {})
au({ "WinClosed" },                                             buffers.wipe_unwanted,    {})
au({ "BufLeave", "FocusLost" },                                 buffers.update,           { nested = true })
au({ "QuickFixCmdPost" },                                       windows.qf_open,          { nested = true })
au({ "WinEnter" },                                              windows.man_width,        { pattern = { "man://*" } })
au({ "BufWinEnter" },                                           windows.qf_height,        { pattern = { "quickfix" } })
au({ "BufWinEnter" },                                           windows.doc_position,     {})
au({ "VimResized" },                                            windows.equalise_windows, {})
au({ "VimEnter" },                                              sidebar.vim_enter,        {})

au({ "User" },                                                  env.update_title,         { pattern = { "FugitiveChanged" } })

au({ "FileType" },                                              fugitive.attach,          { pattern = { "fugitive" } })
au({ "FileType" },                                              dev.ft_lua,               { pattern = { "lua" } })
au({ "FileType" },                                              dev.ft_c,                 { pattern = { "c", "cpp" } })
au({ "FileType" },                                              buffers.default_modeline, { pattern = { "lua", "json", "yml", "yaml", "ts", "tf" } })

au({ "OptionSet" },                                             buffers.option_set_tw,    { pattern = { "textwidth" } })
