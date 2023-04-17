local buffers = require("amc.buffers")
local env = require("amc.env")
local windows = require("amc.windows")
local nvim_tree = require("amc.plugins.nvt")

local group = vim.api.nvim_create_augroup("amc", { clear = true })

local function au_(event, callback)
  vim.api.nvim_create_autocmd(event, { group = group, callback = callback })
end

local function aup(event, pattern, callback)
  vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback })
end

local function aun(event, callback)
  vim.api.nvim_create_autocmd(event, { group = group, nested = true, callback = callback })
end

-- env
au_({ "BufWritePost", "DirChanged", "FocusGained", "VimEnter" }, env.update_title)
au_({ "DirChanged", "VimEnter" }, env.update_path)

-- buffer
au_({ "BufEnter" }, buffers.wipe_alt_no_name_new)
au_({ "WinClosed" }, buffers.wipe_unwanted)
aun({ "BufLeave", "FocusLost" }, buffers.update)

-- quick fix
aun("QuickFixCmdPost", windows.open_qf_loc_win)
aup("BufWinEnter", "quickfix", windows.resize_qf_loc_win)

-- nvim-tree startup
au_("VimEnter", nvim_tree.open_nvim_tree)

-- no way to remap fugitive and tpope will not add
aup("FileType", "fugitive", function(data)
  vim.keymap.set("n", "t", "=", { buffer = data.buf, remap = true })
  vim.keymap.set("n", "x", "X", { buffer = data.buf, remap = true })
end)

-- man is not useful, vim help usually is
aup("FileType", { "lua" }, function(data)
  vim.api.nvim_buf_set_option(data.buf, "keywordprg", ":help")
end)

-- line comments please
aup("FileType", { "c", "cpp" }, function(data)
  vim.api.nvim_buf_set_option(data.buf, "commentstring", "// %s")
end)

-- keep these roughly in sync with ~/.editorconfig, which will not be found outside of ~
aup("FileType", { "lua", "json", "yml", "yaml", "ts", "tf" }, function(data)
  vim.bo[data.buf].expandtab = true
  vim.bo[data.buf].shiftwidth = 2
  vim.bo[data.buf].softtabstop = 2
  vim.bo[data.buf].tabstop = 2
end)
