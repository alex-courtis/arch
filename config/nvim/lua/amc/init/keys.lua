local MODES = {
  "n",
  "i",
  "c",
  "v",
  "x",
  "s",
  "o",
}

local LEADERS = {
  "<Space>",
  "<BS>",
}

M = {}

for _, mode in ipairs(MODES) do
  M[mode .. "m" .. "__"] = function(lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { remap = true })
  end
  M[mode .. "m" .. "s_"] = function(lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { remap = true, silent = true })
  end
  M[mode .. "m" .. "_l"] = function(lhs, rhs)
    for _, leader in ipairs(LEADERS) do
      M[mode .. "m" .. "__"](leader .. lhs, rhs)
    end
  end
  M[mode .. "m" .. "sl"] = function(lhs, rhs)
    for _, leader in ipairs(LEADERS) do
      M[mode .. "m" .. "s_"](leader .. lhs, rhs)
    end
  end
end

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
M.vm__("<LeftRelease>", '"*ygv')

M.nm__(";", ":")
M.vm__(";", ":")
M.nm__("q;", "q:")
M.vm__("q;", "q:")
M.nm__("<C-w>;", "<C-w>:")
M.vm__("<C-w>;", "<C-w>:")

M.nmsl(":", ":cclose<CR>")
M.nmsl(";", ":copen<CR>")

M.cm__("<C-j>", "<Down>")
M.cm__("<C-k>", "<Up>")

-- begin left
-- $
-- @
-- \ used by right

M.nmsl("a", ":NvimTreeFindFile!<CR>:NvimTreeFocus<CR>")
M.nmsl("A", ":NvimTreeCollapse<CR>")
M.nmsl("'", ":lua require('amc.windows').close_inc()<CR>")
M.nmsl('"', ":lua require('amc.windows').close_others()<CR>")

M.nmsl(",", ":G<CR>")
M.nmsl("o", ":lua require('amc.windows').go_home_or_next()<CR>")
M.nmsl("O", ":lua require('amc.windows').go_home()<CR>")
M.nmsl("q", ":q<CR>:call amc#win#goHome()<CR>")

M.nmsl(".", ":lua vim.diagnostic.goto_next({wrap = false})<CR>")
M.nmsl("e", ":cnext<CR>")
-- j gitsigns.next_hunk

M.nmsl("p", ":lua vim.diagnostic.goto_prev({wrap = false})<CR>")
M.nmsl("u", ":cprev<CR>")
-- k gitsigns.prev_hunk

M.nmsl("y", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status()<CR>")
M.nmsl("Y", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status_last()<CR>")
M.nmsl("i", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').buffers()<CR>")
M.nmsl("x", ":lua require('amc.buffers').safe_hash()<CR>")

M.nms_("<Space><BS>", ":lua require('amc.buffers').back()<CR>")
M.nms_("<BS><BS>", ":lua require('amc.buffers').back()<CR>")
-- end left

-- begin right
M.nmsl("f", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files()<CR>")
M.nmsl("F", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files_last()<CR>")
M.nmsl("da", ":lua vim.lsp.buf.code_action()<CR>")
M.nmsl("dq", ":lua vim.diagnostic.setqflist()<CR>")
M.nmsl("df", ":lua vim.diagnostic.open_float()<CR>")
M.nmsl("dh", ":lua vim.lsp.buf.hover()<CR>")
M.nmsl("dr", ":lua vim.lsp.buf.rename()<CR>")
-- b

M.nmsl("g", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep()<CR>")
M.nmsl("G", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep_last()<CR>")
M.nmsl("hb", ":G blame<CR>")
-- h* gitsigns
M.nmsl("ma", ":make all<CR>")
M.nmsl("mc", ":make clean<CR>")
M.nmsl("mm", ":make<CR>")
M.nmsl("mn", ":!rm -rf build ; meson build <CR>")
M.nmsl("mt", ":make test<CR>")

M.nmsl("cu", "<Plug>Commentary<Plug>Commentary")
M.nmsl("cc", "<Plug>CommentaryLine")
M.omsl("c", "<Plug>Commentary")
M.nmsl("c", "<Plug>Commentary")
M.xmsl("c", "<Plug>Commentary")
M.nmsl("t", ":lua require('amc.plugins.lsp').goto_definition_or_tag()<CR>")
M.nmsl("T", ":lua vim.lsp.buf.declaration()<CR>")
M.nmsl("w", "<Plug>ReplaceWithRegisterOperatoriw")
M.xmsl("w", "<Plug>ReplaceWithRegisterVisual")
M.nmsl("W", "<Plug>ReplaceWithRegisterLine")

M.nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/")
M.nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
M.vm_l("r", '"*y<Esc>:%s/<C-r>=getreg("*")<CR>/')
M.vm_l("R", '"*y<Esc>:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
M.nmsl("n", ":lua require('amc.plugins.telescope').lsp_references()<CR>")
M.nmsl("v", ":put<CR>'[v']=")
M.nmsl("V", ":put!<CR>'[v']=")

M.nmsl("l", ":syntax match TrailingSpace /\\s\\+$/<CR>")
M.nmsl("L", ":syntax clear TrailingSpace<CR>")
M.nm_l("s", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
M.nm_l("S", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
M.vmsl("s", "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>\"")
M.nmsl("z", ":lua require('amc.dev').format()<CR>")

M.nm_l("/", '/<C-r>=expand("<cword>")<CR><CR>')
M.vm_l("/", '"*y<Esc>/<C-u><C-r>=getreg("*")<CR><CR>')
M.nm_l("-", ":LspStop<CR>:sleep 1<CR>:LspStart<CR>")
M.nmsl("\\", 'gg"_dG')

M.nms_("<BS><Space>", ":lua require('amc.buffers').forward()<CR>")
M.nms_("<Space><Space>", ":lua require('amc.buffers').forward()<CR>")
-- end right

-- stop vim-commentary from creating the default mappings
M.nm__("gc", "<NOP>")

-- vim-vsnip
vim.keymap.set("i", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { remap = true, expr = true })
vim.keymap.set("s", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { remap = true, expr = true })
vim.keymap.set("i", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-next)' : '<S-Tab>'", { remap = true, expr = true })
vim.keymap.set("s", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { remap = true, expr = true })
