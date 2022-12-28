local K = require("amc.keymap")

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
K.vm__("<LeftRelease>", '"*ygv')

K.nm__(";", ":")
K.vm__(";", ":")
K.nm__("q;", "q:")
K.vm__("q;", "q:")
K.nm__("<C-w>;", "<C-w>:")
K.vm__("<C-w>;", "<C-w>:")

K.nmsl(":", ":cclose<CR>")
K.nmsl(";", ":copen<CR>")

K.cm__("<C-j>", "<Down>")
K.cm__("<C-k>", "<Up>")

-- begin left
-- $
-- @
-- \ used by right

K.nmsl("a", ":NvimTreeOpen<CR>")
K.nmsl("A", ":NvimTreeCollapseKeepBuffers<CR>")
K.nmsl("'", ":lua require('amc.windows').close_inc()<CR>")
K.nmsl('"', ":lua require('amc.windows').close_others()<CR>")

K.nmsl(",", ":G<CR>")
K.nmsl("o", ":lua require('amc.windows').go_home_or_next()<CR>")
K.nmsl("O", ":lua require('amc.windows').go_home()<CR>")
K.nmsl("q", ":q<CR>:call amc#win#goHome()<CR>")

K.nmsl(".", ":lua vim.diagnostic.goto_next({wrap = false})<CR>")
K.nmsl("e", ":cnext<CR>")
-- j gitsigns.next_hunk

K.nmsl("p", ":lua vim.diagnostic.goto_prev({wrap = false})<CR>")
K.nmsl("u", ":cprev<CR>")
-- k gitsigns.prev_hunk

K.nmsl("y", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status()<CR>")
K.nmsl("Y", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status_last()<CR>")
K.nmsl("i", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').buffers()<CR>")
K.nmsl("x", ":lua require('amc.buffers').safe_hash()<CR>")

K.nms_("<Space><BS>", ":lua require('amc.buffers').back()<CR>")
K.nms_("<BS><BS>", ":lua require('amc.buffers').back()<CR>")
-- end left

-- begin right
K.nmsl("f", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files()<CR>")
K.nmsl("F", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files_last()<CR>")
K.nmsl("da", ":lua vim.lsp.buf.code_action()<CR>")
K.nmsl("dq", ":lua vim.diagnostic.setqflist()<CR>")
K.nmsl("df", ":lua vim.diagnostic.open_float()<CR>")
K.nmsl("dh", ":lua vim.lsp.buf.hover()<CR>")
K.nmsl("dr", ":lua vim.lsp.buf.rename()<CR>")
-- b

K.nmsl("g", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep()<CR>")
K.nmsl("G", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep_last()<CR>")
K.nmsl("hb", ":G blame<CR>")
-- h* gitsigns
K.nmsl("ma", ":make all<CR>")
K.nmsl("mc", ":make clean<CR>")
K.nmsl("mm", ":make<CR>")
K.nmsl("mn", ":!rm -rf build ; meson build <CR>")
K.nmsl("mt", ":make test<CR>")

K.nmsl("cu", "<Plug>Commentary<Plug>Commentary")
K.nmsl("cc", "<Plug>CommentaryLine")
K.omsl("c", "<Plug>Commentary")
K.nmsl("c", "<Plug>Commentary")
K.xmsl("c", "<Plug>Commentary")
K.nmsl("t", ":lua require('amc.plugins.lsp').goto_definition_or_tag()<CR>")
K.nmsl("T", ":lua vim.lsp.buf.declaration()<CR>")
K.nmsl("w", "<Plug>ReplaceWithRegisterOperatoriw")
K.xmsl("w", "<Plug>ReplaceWithRegisterVisual")
K.nmsl("W", "<Plug>ReplaceWithRegisterLine")

K.nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/")
K.nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
K.vm_l("r", '"*y<Esc>:%s/<C-r>=getreg("*")<CR>/')
K.vm_l("R", '"*y<Esc>:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
K.nmsl("n", ":lua require('amc.plugins.telescope').lsp_references()<CR>")
K.nmsl("v", ":put<CR>'[v']=")
K.nmsl("V", ":put!<CR>'[v']=")

K.nmsl("l", ":syntax match TrailingSpace /\\s\\+$/<CR>")
K.nmsl("L", ":syntax clear TrailingSpace<CR>")
K.nm_l("s", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
K.nm_l("S", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
K.vmsl("s", "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>\"")
K.nmsl("z", ":lua require('amc.dev').format()<CR>")

K.nm_l("/", '/<C-r>=expand("<cword>")<CR><CR>')
K.vm_l("/", '"*y<Esc>/<C-u><C-r>=getreg("*")<CR><CR>')
K.nm_l("-", ":LspStop<CR>:sleep 1<CR>:LspStart<CR>")
K.nmsl("\\", 'gg"_dG')

K.nms_("<BS><Space>", ":lua require('amc.buffers').forward()<CR>")
K.nms_("<Space><Space>", ":lua require('amc.buffers').forward()<CR>")
-- end right

-- stop vim-commentary from creating the default mappings
K.nm__("gc", "<NOP>")

-- vim-vsnip
vim.keymap.set("i", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { remap = true, expr = true })
vim.keymap.set("s", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { remap = true, expr = true })
vim.keymap.set("i", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-next)' : '<S-Tab>'", { remap = true, expr = true })
vim.keymap.set("s", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { remap = true, expr = true })
