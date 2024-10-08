local require = require("amc.require_or_nil")

local dev = require("amc.dev") or {}
local buffers = require("amc.buffers") or {}
local windows = require("amc.windows") or {}

local fugitive = require("amc.plugins.fugitive") or {}
local lsp = require("amc.plugins.lsp") or {}
local nvt = require("amc.plugins.nvt") or {}
local rainbow = require("amc.plugins.rainbow") or {}
local telescope = require("amc.plugins.telescope") or {}

local K = {}
local M = {}

-- stylua: ignore start
for _, mode in ipairs({ "n", "i", "c", "v", "x", "s", "o" }) do
  K[mode .. "m" .. "__"] = function(lhs, rhs) if rhs then vim.keymap.set(mode, lhs, rhs, { remap = false }) end end
  K[mode .. "m" .. "s_"] = function(lhs, rhs) if rhs then vim.keymap.set(mode, lhs, rhs, { remap = false, silent = true }) end end
  K[mode .. "m" .. "_l"] = function(lhs, rhs) if rhs then for _, leader in ipairs({ "<Space>", "<BS>" }) do K[mode .. "m" .. "__"](leader .. lhs, rhs) end end end
  K[mode .. "m" .. "sl"] = function(lhs, rhs) if rhs then for _, leader in ipairs({ "<Space>", "<BS>" }) do K[mode .. "m" .. "s_"](leader .. lhs, rhs) end end end
end
-- stylua: ignore end

-- normal mode escape clears highlight
local ESC = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
K.nm__("<Esc>", function()
  vim.cmd.nohlsearch()
  vim.api.nvim_feedkeys(ESC, "n", false)
end)

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
K.vm__("<LeftRelease>",  '"*ygv')

K.nms_("<Space><BS>",    ":silent BB<CR>")
K.nms_("<BS><BS>",       ":silent BB<CR>")

K.nms_("<BS><Space>",    ":silent BF<CR>")
K.nms_("<Space><Space>", ":silent BF<CR>")

--
-- left
--
K.nm__(";",     ":")
K.vm__(";",     ":")
K.nm__("q;",    "q:")
K.vm__("q;",    "q:")

K.nms_("yn",    ':let @+ = expand("%:t")<CR>')
K.nms_("yr",    ':let @+ = expand("%:.")<CR>')
K.nms_("ya",    ':let @+ = expand("%:p")<CR>')

K.cm__("<C-j>", "<Down>")
K.cm__("<C-k>", "<Up>")

K.nmsl(";",     vim.cmd.copen)
K.nmsl(":",     vim.cmd.cclose)
K.nmsl("a",     nvt.open_find)
K.nmsl("A",     nvt.open_find_update_root)
K.nmsl("'",     windows.close_inc)
K.nmsl('"',     windows.close_others)

K.nmsl(",",     fugitive.open)
K.nmsl("o",     windows.go_home_or_next)
K.nmsl("O",     vim.cmd.only)
K.nmsl("q",     windows.close)

K.nm_l("}",     ": <C-r>=expand('%:p')<CR><Home>")
K.nm_l("3",     ": <C-r>=expand('%:.')<CR><Home>")
K.nmsl(".",     lsp.goto_next)
K.nmsl("e",     windows.cnext)

K.nm_l("(",     ": <C-r>=expand('<cword>')<CR><Home>")
K.vm_l("(",     '"*y: <C-r>=getreg("*")<CR><Home>')
K.nmsl("p",     lsp.goto_prev)
K.nmsl("u",     windows.cprev)

K.nmsl("y",     telescope.git_status)
K.nmsl("i",     telescope.buffers)
K.nm_l("I",     telescope.builtin)
K.nmsl("x",     ":silent BA<CR>")

--
-- right
--

K.nm__("*",  "<Plug>(asterisk-z*)")
K.nm_l("*",  "*")
K.nmsl("f",  telescope.find_files)
K.nmsl("F",  telescope.find_files_hidden)
K.nmsl("da", vim.lsp.buf.code_action)
K.nmsl("dq", vim.diagnostic.setqflist)
K.nmsl("df", vim.diagnostic.open_float)
K.nmsl("dh", vim.lsp.buf.hover)
K.nmsl("dl", telescope.diagnostics)
K.nmsl("dr", dev.lsp_rename)
K.nmsl("b",  ":%y<CR>")
K.nmsl("B",  ":%d_<CR>")

K.nmsl("g",  telescope.live_grep)
K.nmsl("G",  telescope.live_grep_hidden)
K.nmsl("hb", ":G blame<CR>")
K.nmsl("mc", dev.clean)
K.nmsl("mi", dev.install)
K.nmsl("mm", dev.build)
K.nmsl("mt", dev.test)
K.nmsl("ms", dev.source)

K.nmsl("+",  rainbow.toggle)
K.nmsl("cu", "<Plug>Commentary<Plug>Commentary")
K.nmsl("cc", "<Plug>CommentaryLine")
K.omsl("c",  "<Plug>Commentary")
K.nmsl("c",  "<Plug>Commentary")
K.xmsl("c",  "<Plug>Commentary")
K.nmsl("t",  lsp.goto_definition_or_tag)
K.nmsl("T",  vim.lsp.buf.declaration)
K.nmsl("w",  "<Plug>ReplaceWithRegisterOperatoriw")
K.xmsl("w",  "<Plug>ReplaceWithRegisterVisual")
K.nmsl("W",  "<Plug>ReplaceWithRegisterLine")

K.nm_l("r",  ":%s/<C-r>=expand('<cword>')<CR>/")
K.nm_l("R",  ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
K.vm_l("r",  '"*y:%s/<C-r>=getreg("*")<CR>/')
K.vm_l("R",  '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
K.nmsl("n",  telescope.lsp_references)
K.nmsl("N",  vim.diagnostic.setqflist)
K.nmsl("v",  ":put<CR>'[v']=")
K.nmsl("V",  ":put!<CR>'[v']=")

K.nmsl("l",  buffers.toggle_list)
K.nmsl("L",  buffers.trim_whitespace)
K.nm_l("s",
  ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
K.nm_l("S",
  ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
K.vmsl("s",  "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>")
K.nmsl("z",  dev.format)

K.nm__("#",  "<Plug>(asterisk-z#)")
K.nm_l("#",  "#")
K.nm_l("-",  ":GotoHeaderSwitch<CR>")
K.nm_l("_",  ":GotoHeader<CR>")
K.nmsl("\\", ":silent BW!<CR>")
K.nmsl("|",  buffers.wipe_all)

--
-- vim-vsnip - <Plug> links to the wrong place
--
vim.cmd([[
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
]])

--
-- functions
--

--- au VimEnter
function M.clear_default_mappings()
  -- commentary defaults
  pcall(vim.keymap.del, { "n", "o", "v" }, "gc")
  pcall(vim.keymap.del, "n",               "gcc")
end

--- au BufEnter
--- @param data table
function M.reset_mappings(data)
  --- vim maps K to vim.lsp.buf.hover() in Normal mode
  --- https://github.com/neovim/nvim-lspconfig/blob/b972e7154bc94ab4ecdbb38c8edbccac36f83996/README.md#configuration
  pcall(vim.keymap.del, "n", "K", { buffer = data.buf })
end

return M
