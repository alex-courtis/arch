local K = require("amc.keymap")

local buffers = require("amc.buffers")
local dev = require("amc.dev")
local windows = require("amc.windows")

local nvim_tree = require("amc.plugins.nvt")
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
-- &
-- $
-- @
K.nmsl("\\", buffers.wipe)
K.nmsl("|", buffers.wipe_all)

-- [
K.nmsl("a", nvim_tree.open_find)
K.nmsl("A", nvim_tree.open_find_update_root)
K.nmsl("'", windows.close_inc)
K.nmsl('"', windows.close_others)

-- {
K.nmsl(",", vim.cmd.Git)
K.nmsl("o", windows.go_home_or_next)
K.nmsl("O", windows.go_home)
K.nmsl("q", windows.close)

-- }
K.nmsl(".", lsp.goto_next)
K.nmsl("e", windows.cnext)
-- j gitsigns.next_hunk

-- (
K.nmsl("p", lsp.goto_prev)
K.nmsl("u", windows.cprev)
-- k gitsigns.prev_hunk

-- =
K.nmsl("y", telescope.git_status)
K.nmsl("Y", telescope.git_status_last)
K.nmsl("i", telescope.buffers)
K.nmsl("x", buffers.safe_hash)

K.nms_("<Space><BS>", buffers.back)
K.nms_("<BS><BS>", buffers.back)

-- <Tab>
K.nmsl("<Esc>", ":wincmd p<CR>")

K.nmsl("<Left>", ":wincmd h<CR>")
K.nmsl("<Right>", ":wincmd l<CR>")

-- TODO remove once training complete
vim.cmd([[
nnoremap <C-w>p <Nop>
nnoremap <C-w><C-p> <Nop>
nnoremap <C-w>h <Nop>
nnoremap <C-w><C-h> <Nop>
nnoremap <C-w>l <Nop>
nnoremap <C-w><C-l> <Nop>
]])

-- end left

-- begin right
K.nm_l("*", '/<C-r>=expand("<cword>")<CR><CR>')
K.vm_l("*", '"*y<Esc>/<C-u><C-r>=substitute(getreg("*"), "\\n", "\\\\\\\\n", "g")<CR><CR>') -- escape just newlines for now
K.nmsl("f", telescope.find_files)
K.nmsl("F", telescope.find_files_last)
K.nmsl("da", vim.lsp.buf.code_action)
K.nmsl("dq", vim.diagnostic.setqflist)
K.nmsl("df", vim.diagnostic.open_float)
K.nmsl("dh", vim.lsp.buf.hover)
K.nmsl("dr", vim.lsp.buf.rename)
K.nmsl("b", ":%y<CR>")
K.nmsl("B", ":%d_<CR>")

-- )
K.nmsl("g", telescope.live_grep)
K.nmsl("G", telescope.live_grep_last)
K.nmsl("hb", ":G blame<CR>")
-- h* gitsigns
K.nmsl("mc", dev.clean)
K.nmsl("mi", dev.install)
K.nmsl("mm", dev.build)
K.nmsl("mt", dev.test)
K.nmsl("ms", dev.source)

-- +
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

-- ]
K.nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/")
K.nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
K.vm_l("r", '"*y:%s/<C-r>=getreg("*")<CR>/')
K.vm_l("R", '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
K.nmsl("n", telescope.lsp_references)
K.nmsl("N", vim.diagnostic.setqflist)
K.nmsl("v", ":put<CR>'[v']=")
K.nmsl("V", ":put!<CR>'[v']=")

K.nmsl("!", buffers.toggle_list)
K.nmsl("l", buffers.toggle_trailing_space)
K.nm_l("s", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
K.nm_l("S", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
K.vmsl("s", "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>\"")
K.nmsl("z", dev.format)

-- #
-- /
K.nm_l("-", ":GotoHeaderSwitch<CR>")
K.nm_l("_", ":GotoHeader<CR>")
-- \ defined at left

K.nms_("<BS><Space>", buffers.forward)
K.nms_("<Space><Space>", buffers.forward)

-- <Del>
K.nmsl("<CR>", ":wincmd w<CR>")
K.nmsl("<S-CR>", ":wincmd W<CR>")

K.nmsl("<Up>", ":wincmd k<CR>")
K.nmsl("<Down>", ":wincmd j<CR>")

-- TODO remove once training complete
vim.cmd([[
nnoremap <C-w>w <Nop>
nnoremap <C-w><C-w> <Nop>
nnoremap <C-w>W <Nop>
nnoremap <C-w><C-W> <Nop>
nnoremap <C-w>k <Nop>
nnoremap <C-w><C-k> <Nop>
nnoremap <C-w>j <Nop>
nnoremap <C-w><C-j> <Nop>
]])
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
