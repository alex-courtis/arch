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

local K = {}
local M = {}

---nil safe wrappers around vim.keymap.set() rhs
for _, mode in ipairs({ "n", "i", "c", "v", "x", "s", "o" }) do
  K[mode .. "m" .. "__"] = function(lhs, rhs)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { remap = false })
    end
  end
  K[mode .. "m" .. "s_"] = function(lhs, rhs)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { remap = false, silent = true })
    end
  end
  K[mode .. "m" .. "_l"] = function(lhs, rhs)
    if rhs then
      for _, leader in ipairs({ "<Space>", "<BS>" }) do
        K[mode .. "m" .. "__"](leader .. lhs, rhs)
      end
    end
  end
  K[mode .. "m" .. "sl"] = function(lhs, rhs)
    if rhs then
      for _, leader in ipairs({ "<Space>", "<BS>" }) do
        K[mode .. "m" .. "s_"](leader .. lhs, rhs)
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
K.vm__("<LeftRelease>",  '"*ygv')

K.nms_("<BS><BS>",       ":silent BB<CR>")
K.nms_("<Space><Space>", ":silent BF<CR>")

--
-- left
--
K.nm__(";",     ":")
K.vm__(";",     ":")

K.nms_("ya",    ':let @+ = expand("%:p")<CR>')
K.nms_("yc",    ":let @+ = getcwd()<CR>")
K.nms_("yn",    ':let @+ = expand("%:t")<CR>')
K.nms_("yr",    ':let @+ = expand("%:.")<CR>')

K.cm__("<C-j>", "<Down>")
K.cm__("<C-k>", "<Up>")

-- [7
K.nmsl(";", vim.cmd.copen)
K.nmsl(":", vim.cmd.cclose)
K.nmsl("a", nvt.open_find)
K.nmsl("A", nvt.open_find_update_root)
K.nmsl("'", windows.close_inc)
K.nmsl('"', windows.close_others)

-- 5<Q
K.nm_l("{", "[{")
K.nmsl(",", fugitive.open)
K.nmsl("o", windows.go_home_or_next)
K.nmsl("O", vim.cmd.only)
K.nmsl("q", windows.close)

-- 3>EJ
K.nm_l("}", "]}")
K.nmsl(".", lsp.goto_next)
K.nmsl("e", windows.cnext)
-- j gitsigns

-- 3PUK
K.nm_l("(", "[(")
K.nmsl("p", lsp.goto_prev)
K.nmsl("u", windows.cprev)
-- k gitsigns

-- =9YX
K.nmsl("y", telescope.git_status)
K.nmsl("i", telescope.buffers)
K.nm_l("I", telescope.builtin)
K.nmsl("x", ":silent BA<CR>")

--
-- right
--

-- 0D
K.nm__("*",  "<Plug>(asterisk-z*)")
K.nm_l("*",  "*")
K.nmsl("f",  telescope.find_files)
K.nmsl("F",  telescope.find_files_hidden)
-- d lsp
K.nmsl("b",  ":%y<CR>")
K.nmsl("B",  ":%d_<CR>")

-- 2HM
K.nm_l(")",  "])")
K.nmsl("g",  telescope.live_grep)
K.nmsl("G",  telescope.live_grep_hidden)
K.nmsl("hb", ":G blame<CR>")
-- h gitsigns
K.nmsl("mc", dev.clean)
K.nmsl("mi", dev.install)
K.nmsl("mm", dev.build)
K.nmsl("mt", dev.test)
K.nmsl("ms", dev.source)

-- 4C
K.nmsl("+",  rainbow.toggle)
K.nmsl("cu", "<Plug>Commentary<Plug>Commentary")
K.nmsl("cc", "<Plug>CommentaryLine")
K.omsl("c",  "<Plug>Commentary")
K.nmsl("c",  "<Plug>Commentary")
K.xmsl("c",  "<Plug>Commentary")
K.nmsl("t",  "<C-]>")
K.nmsl("w",  "<Plug>ReplaceWithRegisterOperatoriw")
K.xmsl("w",  "<Plug>ReplaceWithRegisterVisual")
K.nmsl("W",  "<Plug>ReplaceWithRegisterLine")

-- ]6N
K.nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
K.nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/")
K.vm_l("r", '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
K.vm_l("R", '"*y:%s/<C-r>=getreg("*")<CR>/')
K.nmsl("n", telescope.lsp_references)
K.nmsl("N", vim.diagnostic.setqflist)
K.nmsl("v", ":put<CR>'[v']=")
K.nmsl("V", ":put!<CR>'[v']=")

-- Z
K.nm_l("!",     ": <C-r>=expand('%:.')<CR><Home>")
K.vm_l("!",     '"*y: <C-r>=getreg("*")<CR><Home>')
K.nm_l("8",     ": <C-r>=expand('%:p')<CR><Home>")
K.nmsl("l", buffers.toggle_list)
K.nmsl("L", buffers.trim_whitespace)
K.nm_l("s",
  ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
K.nm_l("S",
  ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
K.vmsl("s", "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>")
K.nmsl("z", dev.format)

-- `?-_|
K.nm__("#",  "<Plug>(asterisk-z#)")
K.nm_l("#",  "#")
K.nm_l("/",  '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
K.nm_l("?",  '<cmd>lua require("spectre").open()<CR>')
K.vm_l("/",  '<esc><cmd>lua require("spectre").open_visual()<CR>')
K.nmsl("-",  buffers.wipe_all)
K.nmsl("\\", ":silent BW!<CR>")

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
-- functions
--

---au VimEnter
function M.clear_default_mappings()
  -- commentary defaults
  pcall(vim.keymap.del, { "n", "o", "v" }, "gc")
  pcall(vim.keymap.del, "n",               "gcc")
end

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
