local LEADERS = {
  "<Space>",
  "<BS>",
}

local function cm__(lhs, rhs)
  vim.keymap.set("c", lhs, rhs, { remap = true })
end

local function nm__(lhs, rhs)
  vim.keymap.set("n", lhs, rhs, { remap = true })
end

local function nms_(lhs, rhs)
  vim.keymap.set("n", lhs, rhs, { remap = true, silent = true })
end

local function oms_(lhs, rhs)
  vim.keymap.set("o", lhs, rhs, { remap = true, silent = true })
end

local function vms_(lhs, rhs)
  vim.keymap.set("v", lhs, rhs, { remap = true, silent = true })
end

local function xms_(lhs, rhs)
  vim.keymap.set("x", lhs, rhs, { remap = true, silent = true })
end

local function vm__(lhs, rhs)
  vim.keymap.set("v", lhs, rhs, { remap = true })
end

local function nm_l(lhs, rhs)
  for _, leader in ipairs(LEADERS) do
    nm__(leader .. lhs, rhs)
  end
end

local function nmsl(lhs, rhs)
  for _, leader in ipairs(LEADERS) do
    nms_(leader .. lhs, rhs)
  end
end

local function omsl(lhs, rhs)
  for _, leader in ipairs(LEADERS) do
    oms_(leader .. lhs, rhs)
  end
end

local function vm_l(lhs, rhs)
  for _, leader in ipairs(LEADERS) do
    vm__(leader .. lhs, rhs)
  end
end

local function vmsl(lhs, rhs)
  for _, leader in ipairs(LEADERS) do
    vms_(leader .. lhs, rhs)
  end
end

local function xmsl(lhs, rhs)
  for _, leader in ipairs(LEADERS) do
    xms_(leader .. lhs, rhs)
  end
end

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
vm__("<LeftRelease>", '"*ygv')

nm__(";", ":")
vm__(";", ":")
nm__("q;", "q:")
vm__("q;", "q:")
nm__("<C-w>;", "<C-w>:")
vm__("<C-w>;", "<C-w>:")

nmsl(":", ":cclose<CR>")
nmsl(";", ":copen<CR>")

cm__("<C-j>", "<Down>")
cm__("<C-k>", "<Up>")

-- begin left
-- $
-- @
-- \ used by right

nmsl("a", ":NvimTreeFindFile!<CR>:NvimTreeFocus<CR>")
nmsl("A", ":NvimTreeCollapse<CR>")
nmsl("'", ":lua require('amc.windows').close_inc()<CR>")
nmsl('"', ":lua require('amc.windows').close_others()<CR>")

nmsl(",", ":G<CR>")
nmsl("o", ":lua require('amc.windows').go_home_or_next()<CR>")
nmsl("O", ":lua require('amc.windows').go_home()<CR>")
nmsl("q", ":q<CR>:call amc#win#goHome()<CR>")

nmsl(".", ":lua vim.diagnostic.goto_next({wrap = false})<CR>")
nmsl("e", ":cnext<CR>")
-- j gitsigns.next_hunk

nmsl("p", ":lua vim.diagnostic.goto_prev({wrap = false})<CR>")
nmsl("u", ":cprev<CR>")
-- k gitsigns.prev_hunk

nmsl("y", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status()<CR>")
nmsl("Y", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').git_status_last()<CR>")
nmsl("i", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').buffers()<CR>")
nmsl("x", ":lua require('amc.buffers').safe_hash()<CR>")

nms_("<Space><BS>", ":lua require('amc.buffers').back()<CR>")
nms_("<BS><BS>", ":lua require('amc.buffers').back()<CR>")
-- end left

-- begin right
nmsl("f", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files()<CR>")
nmsl("F", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').find_files_last()<CR>")
nmsl("da", ":lua vim.lsp.buf.code_action()<CR>")
nmsl("dq", ":lua vim.diagnostic.setqflist()<CR>")
nmsl("df", ":lua vim.diagnostic.open_float()<CR>")
nmsl("dh", ":lua vim.lsp.buf.hover()<CR>")
nmsl("dr", ":lua vim.lsp.buf.rename()<CR>")
-- b

nmsl("g", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep()<CR>")
nmsl("G", ":call amc#win#goHome() <Bar> :lua require('amc.plugins.telescope').live_grep_last()<CR>")
nmsl("hb", ":G blame<CR>")
-- h* gitsigns
nmsl("ma", ":make all<CR>")
nmsl("mc", ":make clean<CR>")
nmsl("mm", ":make<CR>")
nmsl("mn", ":!rm -rf build ; meson build <CR>")
nmsl("mt", ":make test<CR>")

nmsl("cu", "<Plug>Commentary<Plug>Commentary")
nmsl("cc", "<Plug>CommentaryLine")
omsl("c", "<Plug>Commentary")
nmsl("c", "<Plug>Commentary")
xmsl("c", "<Plug>Commentary")
nmsl("t", ":lua require('amc.plugins.lsp').goto_definition_or_tag()<CR>")
nmsl("T", ":lua vim.lsp.buf.declaration()<CR>")
nmsl("w", "<Plug>ReplaceWithRegisterOperatoriw")
xmsl("w", "<Plug>ReplaceWithRegisterVisual")
nmsl("W", "<Plug>ReplaceWithRegisterLine")

nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/")
nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>")
vm_l("r", '"*y<Esc>:%s/<C-r>=getreg("*")<CR>/')
vm_l("R", '"*y<Esc>:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>')
nmsl("n", ":lua require('amc.plugins.telescope').lsp_references()<CR>")
nmsl("v", ":put<CR>'[v']=")
nmsl("V", ":put!<CR>'[v']=")

nmsl("l", ":syntax match TrailingSpace /\\s\\+$/<CR>")
nmsl("L", ":syntax clear TrailingSpace<CR>")
nm_l("s", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cword>')<CR>', initial_mode = \"normal\" })<CR>")
nm_l("S", ":lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=expand('<cWORD>')<CR>', initial_mode = \"normal\" })<CR>")
vmsl("s", "\"*y<Esc>:<C-u>lua require('amc.plugins.telescope').live_grep( { default_text = '<C-r>=getreg(\"*\")<CR>' })<CR>\"")
nmsl("z", ":lua require('amc.dev').format()<CR>")

nm_l("/", '/<C-r>=expand("<cword>")<CR><CR>')
vm_l("/", '"*y<Esc>/<C-u><C-r>=getreg("*")<CR><CR>')
nm_l("-", ":LspStop<CR>:sleep 1<CR>:LspStart<CR>")
nmsl("\\", 'gg"_dG')

nms_("<BS><Space>", ":lua require('amc.buffers').forward()<CR>")
nms_("<Space><Space>", ":lua require('amc.buffers').forward()<CR>")
-- end right

-- stop vim-commentary from creating the default mappings
nm__("gc", "<NOP>")

-- vim-vsnip
vim.keymap.set("i", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { remap = true, expr = true })
vim.keymap.set("s", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { remap = true, expr = true })
vim.keymap.set("i", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-next)' : '<S-Tab>'", { remap = true, expr = true })
vim.keymap.set("s", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { remap = true, expr = true })
