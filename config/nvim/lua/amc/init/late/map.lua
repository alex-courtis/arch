local require = require("amc.require_or_nil")

local env = require("amc.env") or {}
local dev = require("amc.dev") or {}
local buffers = require("amc.buffers") or {}
local windows = require("amc.windows") or {}

local fugitive = require("amc.plugins.fugitive") or {}
local lsp = require("amc.plugins.lsp") or {}
local nvt = require("amc.plugins.nvt") or {}
local rainbow = require("amc.plugins.rainbow") or {}
local telescope = require("amc.plugins.telescope") or {}
local treesitter = require("amc.plugins.treesitter") or {}
local which_key = require("amc.plugins.which-key") or {}

local K = {}
local M = {}

local function nop()
end

---nil safe wrappers around vim.keymap.set() rhs
for _, mode in ipairs({ "n", "i", "c", "v", "x", "s", "o" }) do
  K[mode .. "m" .. "__"] = function(lhs, rhs, desc)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = false, })
    end
  end
  K[mode .. "m" .. "s_"] = function(lhs, rhs, desc)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = false, silent = true, })
    end
  end
  K[mode .. "m" .. "_l"] = function(lhs, rhs, desc)
    if rhs then
      for _, leader in ipairs({ "<Space>", "<BS>" }) do
        K[mode .. "m" .. "__"](leader .. lhs, rhs, desc)
      end
    end
  end
  K[mode .. "m" .. "sl"] = function(lhs, rhs, desc)
    if rhs then
      for _, leader in ipairs({ "<Space>", "<BS>" }) do
        K[mode .. "m" .. "s_"](leader .. lhs, rhs, desc)
      end
    end
  end
end

---nil safe wrapper around vim.api.nvim_create_user_command()
---@param name string
---@param command any
---@param opts vim.api.keyset.user_command
local function uc(name, command, opts)
  if command then
    vim.api.nvim_create_user_command(name, command, opts)
  end
end

-- normal mode escape clears highlight and snippets
local ESC = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
K.nm__("<Esc>", function()
  vim.snippet.stop()
  vim.cmd.nohlsearch()
  vim.api.nvim_feedkeys(ESC, "n", false)
end)

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
K.vm__("<LeftRelease>",  '"*ygv',          "Autoselect")

K.nm__("<C-j>",          "<C-w>j")
K.nm__("<C-k>",          "<C-w>k")
K.nm__("<C-l>",          "<C-w>l")
K.nm__("<C-h>",          "<C-w>h")
K.nm__("<C-Space>",      "<C-w>w")
K.nm__("<C-S-Space>",    "<C-w>W")
-- remove once above is trained
K.nm__("<C-w><C-j>",     "<NOP>")
K.nm__("<C-w>j",         "<NOP>")
K.nm__("<C-w><C-J>",     "<NOP>")
K.nm__("<C-w>J",         "<NOP>")
K.nm__("<C-w><C-k>",     "<NOP>")
K.nm__("<C-w>k",         "<NOP>")
K.nm__("<C-w><C-K>",     "<NOP>")
K.nm__("<C-w>K",         "<NOP>")
K.nm__("<C-w><C-l>",     "<NOP>")
K.nm__("<C-w>l",         "<NOP>")
K.nm__("<C-w><C-L>",     "<NOP>")
K.nm__("<C-w>L",         "<NOP>")
K.nm__("<C-w><C-h>",     "<NOP>")
K.nm__("<C-w>h",         "<NOP>")
K.nm__("<C-w><C-H>",     "<NOP>")
K.nm__("<C-w>H",         "<NOP>")
K.nm__("<C-w><C-w>",     "<NOP>")
K.nm__("<C-w>w",         "<NOP>")
K.nm__("<C-w><C-W>",     "<NOP>")
K.nm__("<C-w>W",         "<NOP>")

K.nms_("<BS><BS>",       ":silent BB<CR>", "Prev Buffer")
K.nms_("<Space><Space>", ":silent BF<CR>", "Next Buffer")

--
-- left
--
K.nm__(";",     ":")
K.vm__(";",     ":")

K.nms_("ya",    ':let @+ = expand("%:p")<CR>', "Yank Absolute Path")
K.nms_("yc",    ":let @+ = getcwd()<CR>",      "Yank cwd")
K.nms_("yn",    ':let @+ = expand("%:t")<CR>', "Yank Name")
K.nms_("yr",    ':let @+ = expand("%:.")<CR>', "Yank Relative Path")

K.cm__("<C-j>", "<Down>")
K.cm__("<C-k>", "<Up>")

-- [7
K.nmsl(";", vim.cmd.copen,             "Open Quickfix")
K.nmsl(":", vim.cmd.cclose,            "Close Quickfix")
K.nmsl("a", nvt.open_find,             "Open nvim-tree Update Root")
K.nmsl("A", nvt.open_find_update_root, "Open nvim-tree")
K.nmsl("'", windows.close_inc,         "Close Lowest Window")
K.nmsl('"', windows.close_others,      "Close Other Windows")

-- 5Q
K.nm_l("{", "[{")
K.nmsl(",", fugitive.open_only,      "Open Only Fugitive")
K.nmsl("<", fugitive.open,           "Open Fugitive")
K.nmsl("o", windows.go_home_or_next, "Home Or Next Window")
K.nmsl("O", vim.cmd.only,            "Only")
K.nmsl("q", windows.close,           "Close Window")

-- 3>EJ
K.nm_l("}", "]}")
K.nmsl(".", lsp.goto_next, "Next Diagnostic")
K.nmsl("e", windows.cnext, "Next QF")
-- j gitsigns

-- 3PUK
K.nm_l("(", "[(")
K.nmsl("p", lsp.goto_prev, "Prev Diagnostic")
K.nmsl("u", windows.cprev, "Prev QF")
-- k gitsigns

-- =9YX
K.nmsl("y", telescope.git_status, "Telescope Git Status")
K.nmsl("i", telescope.buffers,    "Telescope Buffers")
K.nm_l("I", telescope.builtin,    "Telescope Builtins")
K.nmsl("x", ":silent BA<CR>",     "Alt Buffer")

--
-- right
--

-- 0D
K.nm__("*", "<Plug>(asterisk-z*)",       "z*")
K.nm_l("*", "*",                         "*")
K.nmsl("f", telescope.find_files,        "Telescope Files")
K.nmsl("F", telescope.find_files_hidden, "Telescope Files Hidden")
-- d lsp
K.nmsl("b", ":%y<CR>",                   "Yank Buffer")
K.nmsl("B", ":%d_<CR>",                  "Clean Buffer")

-- 2HM
K.nm_l(")",  "])",                       "Next )")
K.nmsl("g",  telescope.live_grep,        "Telescope Grep")
K.nmsl("G",  telescope.live_grep_hidden, "Telescope Grep Hidden")
K.nmsl("hb", ":G blame<CR>",             "Fugitive Blame")
-- h gitsigns
K.nmsl("mc", dev.clean)
K.nmsl("mi", dev.install)
K.nmsl("mm", dev.build)
K.nmsl("mt", dev.test)
K.nmsl("mT", dev.test_all)
K.nmsl("ms", dev.source)

-- 4cC
K.nmsl("+",  rainbow.toggle)
K.nmsl("cu", nop)
K.nmsl("cc", nop)
K.omsl("c",  nop)
K.nmsl("c",  nop)
K.xmsl("c",  nop)
K.nmsl("t",  "<C-]>")
K.nmsl("w",  "<Plug>ReplaceWithRegisterOperatoriw")
K.xmsl("w",  "<Plug>ReplaceWithRegisterVisual")
K.nmsl("W",  "<Plug>ReplaceWithRegisterLine")

-- ]6N
K.nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
K.nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/")
K.vm_l("r", '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
K.vm_l("R", '"*y:%s/<C-r>=getreg("*")<CR>/')
-- n lsp
K.nmsl("v", ":put<CR>'[v']=")
K.nmsl("V", ":put!<CR>'[v']=")

-- Z
K.nm_l("!", ": <C-r>=expand('%:.')<CR><Home>")
K.vm_l("!", '"*y: <C-r>=getreg("*")<CR><Home>')
K.nm_l("8", ": <C-r>=expand('%:p')<CR><Home>")
K.nmsl("l", buffers.toggle_list)
K.nmsl("L", buffers.trim_whitespace)
K.nm_l("s",
  ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
K.nm_l("S",
  ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
K.vmsl("s", "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>")
K.nmsl("z", dev.format)

-- `|
K.nm__("#",  "<Plug>(asterisk-z#)",                                             "z#")
K.nm_l("#",  "#",                                                               "#")
K.nm_l("/",  '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
K.nm_l("?",  '<cmd>lua require("spectre").open()<CR>')
K.vm_l("/",  '<esc><cmd>lua require("spectre").open_visual()<CR>')
K.nmsl("-",  buffers.wipe_all)
K.nmsl("_",  ":silent BW!<CR>")
K.nmsl("\\", which_key.show)

---
--- snippets
---

---Jump if snippet active otherwise feed key
---@param lhs string
---@param direction vim.snippet.Direction
---@return string|nil
local function jump(lhs, direction)
  if vim.snippet.active({ direction = direction }) then
    return vim.snippet.jump(direction)
  else
    return lhs
  end
end

vim.keymap.set({ "i", "s" }, "<Tab>",   function() return jump("<Tab>", 1) end,    { expr = true })
vim.keymap.set({ "i", "s" }, "<S-Tab>", function() return jump("<S-Tab>", -1) end, { expr = true })

--
-- commands
--

uc("CD",     env.cd,                      {})
uc("PS",     "PackerSync",                {})
uc("RD",     telescope.grep_in_directory, { nargs = "+", complete = "dir" })
uc("RT",     telescope.grep_by_filetype,  { nargs = 1 })
uc("S",      buffers.exec_to_buffer,      { nargs = "+", complete = "expression" })
uc("TSBase", treesitter.install_base,     {})

return M
