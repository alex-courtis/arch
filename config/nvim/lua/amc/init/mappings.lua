local K = require("amc.keymap")

local buffers = require("amc.buffers")
local dev = require("amc.dev")
local windows = require("amc.windows")

local nvim_tree = require("amc.plugins.nvim-tree")
local telescope = require("amc.plugins.telescope")
local lsp = require("amc.plugins.lsp")

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
K.vm__("<LeftRelease>", '"*ygv')

K.nm__(";", ":")
K.vm__(";", ":")
K.nm__("q;", "q:")
K.vm__("q;", "q:")

K.nmsl(":", vim.cmd.cclose)
K.nmsl(";", vim.cmd.copen)

K.cm__("<C-j>", "<Down>")
K.cm__("<C-k>", "<Up>")

-- normal mode escape clears highlight
local ESC = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
K.nm__("<Esc>", function()
  vim.cmd.nohlsearch()
  vim.api.nvim_feedkeys(ESC, "n", false)
end)

-- begin left
-- $
-- @
-- \ used by right

K.nmsl("a", nvim_tree.find_focus)
K.nmsl("A", nvim_tree.collapse_find)
K.nmsl("'", windows.close_inc)
K.nmsl('"', windows.close_others)

K.nmsl(",", vim.cmd.Git)
K.nmsl("o", windows.go_home_or_next)
K.nmsl("O", windows.go_home)
K.nmsl("q", windows.close)
K.nmsl(".", lsp.goto_next)
K.nmsl("e", windows.cnext)
-- j gitsigns.next_hunk

K.nmsl("p", lsp.goto_prev)
K.nmsl("u", windows.cprev)
-- k gitsigns.prev_hunk

K.nmsl("y", telescope.git_status)
K.nmsl("Y", telescope.git_status_last)
K.nmsl("i", telescope.buffers)
K.nmsl("x", buffers.safe_hash)

K.nms_("<Space><BS>", buffers.back)
K.nms_("<BS><BS>", buffers.back)
-- end left

-- begin right
K.nmsl("f", telescope.find_files)
K.nmsl("F", telescope.find_files_last)
K.nmsl("da", vim.lsp.buf.code_action)
K.nmsl("dq", vim.diagnostic.setqflist)
K.nmsl("df", vim.diagnostic.open_float)
K.nmsl("dh", vim.lsp.buf.hover)
K.nmsl("dr", vim.lsp.buf.rename)
-- b

K.nmsl("g", telescope.live_grep)
K.nmsl("G", telescope.live_grep_last)
K.nmsl("hb", ":G blame<CR>")
-- h* gitsigns
K.nmsl("mc", dev.clean)
K.nmsl("mm", dev.build)
K.nmsl("mr", dev.reconfigure)
K.nmsl("mt", dev.test)
K.nmsl("ms", dev.source)

K.nmsl("cu", "<Plug>Commentary<Plug>Commentary")
K.nmsl("cc", "<Plug>CommentaryLine")
K.omsl("c", "<Plug>Commentary")
K.nmsl("c", "<Plug>Commentary")
K.xmsl("c", "<Plug>Commentary")
K.nmsl("t", lsp.goto_definition_or_tag)
K.nmsl("T", vim.lsp.buf.declaration)
K.nmsl("w", "<Plug>ReplaceWithRegisterOperatoriw")
K.xmsl("w", "<Plug>ReplaceWithRegisterVisual")
K.nmsl("W", "<Plug>ReplaceWithRegisterLine")

K.nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/")
K.nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
K.vm_l("r", '"*y:%s/<C-r>=getreg("*")<CR>/')
K.vm_l("R", '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
K.nmsl("n", telescope.lsp_references)
K.nmsl("v", ":put<CR>'[v']=")
K.nmsl("V", ":put!<CR>'[v']=")

K.nmsl("l", ":syntax match TrailingSpace /\\s\\+$/<CR>")
K.nmsl("L", ":syntax clear TrailingSpace<CR>")
K.nm_l("s", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
K.nm_l("S", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
K.vmsl("s", "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>\"")
K.nmsl("z", dev.format)

K.nm_l("/", '/<C-r>=expand("<cword>")<CR><CR>')
K.vm_l("/", '"*y<Esc>/<C-u><C-r>=getreg("*")<CR><CR>')
K.nm_l("-", ":LspStop<CR>:sleep 1<CR>:LspStart<CR>")
K.nmsl("\\", 'gg"_dG')

K.nms_("<BS><Space>", buffers.forward)
K.nms_("<Space><Space>", buffers.forward)
-- end right

-- stop vim-commentary from creating the default mappings
K.nm__("gc", "<NOP>")

-- vim-vsnip - <Plug> links to the wrong place
vim.cmd([[
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
]])
