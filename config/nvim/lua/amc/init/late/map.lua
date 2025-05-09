local require = require("amc.require").or_empty

local env = require("amc.env")
local dev = require("amc.dev")
local buffers = require("amc.buffers")
local windows = require("amc.windows")
local K = require("amc.util").K
local snippet = require("vim.snippet")

local fugitive = require("amc.plugins.fugitive")
local lsp = require("amc.plugins.lsp")
local nvt = require("amc.plugins.nvt")
local rainbow = require("amc.plugins.rainbow")
local telescope = require("amc.plugins.telescope")

local treesitter = require("amc.plugins.treesitter")
local which_key = require("amc.plugins.which-key")

local M = {}

---nil safe wrapper around vim.api.nvim_create_user_command()
---@param name string
---@param command any
---@param opts vim.api.keyset.user_command
local function uc(name, command, opts)
  if command then
    vim.api.nvim_create_user_command(name, command, opts)
  end
end

-- normal mode escape clears highlight
local ESC = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
K.n__("<Esc>", function()
  vim.cmd.nohlsearch()
  vim.api.nvim_feedkeys(ESC, "n", false)
end)

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
K.v__("<LeftRelease>",  '"*ygv',          "Autoselect")

K.n__("<C-j>",          "<C-w>j")
K.n__("<C-k>",          "<C-w>k")
K.n__("<C-l>",          "<C-w>l")
K.n__("<C-h>",          "<C-w>h")
K.n__("<C-Space>",      "<C-w>w")
K.n__("<C-S-Space>",    "<C-w>W")

K.ns_("<BS><BS>",       ":silent BB<CR>", "Prev Buffer")
K.ns_("<Space><Space>", ":silent BF<CR>", "Next Buffer")

--
-- left
--
K.n__(";",     ":")
K.v__(";",     ":")

K.ns_("ys",    ':let @+ = expand("%:p")<CR>', "Yank Absolute Path")
K.ns_("yc",    ":let @+ = getcwd()<CR>",      "Yank cwd")
K.ns_("yn",    ':let @+ = expand("%:t")<CR>', "Yank Name")
K.ns_("yr",    ':let @+ = expand("%:.")<CR>', "Yank Relative Path")

K.c__("<C-j>", "<Down>")
K.c__("<C-k>", "<Up>")

-- [7
--
--
--
K.nsl(";", vim.cmd.copen,             "Open Quickfix")
K.nsl(":", vim.cmd.cclose,            "Close Quickfix")
K.nsl("a", nvt.open_find,             "Open nvim-tree Update Root")
K.nsl("A", nvt.open_find_update_root, "Open nvim-tree")
K.nsl("'", windows.close_inc,         "Close Lowest Window")
K.nsl('"', windows.close_others,      "Close Other Windows")

--  5
--
--  O
--
K.n_l("{", "[{",                    "Prev {")
K.nsl(",", fugitive.open_only,      "Open Only Fugitive")
K.nsl("<", fugitive.open,           "Open Fugitive")
K.nsl("o", windows.go_home_or_next, "Home Or Next Window")
K.nsl("q", windows.close,           "Close Window")
K.nsl("Q", vim.cmd.only,            "Only")

--  3
--  >
--  E
--  J
K.n_l("}", "]}",          "Next }")
K.nsl(".", lsp.goto_next, "Next Diagnostic")
K.nsl("e", windows.cnext, "Next QF")
-- j gitsigns

--  1
--  P
--  U
--  K
K.n_l("(", "[(",          "Prev (")
K.nsl("p", lsp.goto_prev, "Prev Diagnostic")
K.nsl("u", windows.cprev, "Prev QF")
-- k gitsigns

-- =9
-- yY
--  I
--  X
K.nsl("i", telescope.buffers, "Telescope Buffers")
K.nsl("x", ":silent BA<CR>",  "Alt Buffer")

--
-- right
--

--  0
--  F
--  D
--
K.n__("*",  "<Plug>(asterisk-z*)",       "Word Forwards Stay")
K.n_l("*",  "*",                         "Word Forwards")
K.nsl("fd", telescope.git_status,        "Dirty")
K.nsl("ff", telescope.find_files,        "")
K.nsl("fg", telescope.git_files,         "Git")
K.nsl("fh", telescope.find_files_hidden, "Hidden")
K.nsl("fo", telescope.oldfiles,          "Old")
K.nsl("b",  ":%y<CR>",                   "Yank Buffer")
K.nsl("B",  ":%d_<CR>",                  "Clean Buffer")

--  2
--  G
--  H
--  M
K.n_l(")",  "])",                                 "Next )")
K.nsl("gc", telescope.rhs_n_grep_cword,           "cword")
K.nsl("gd", telescope.live_grep_directory_buffer, "Directory, Buffer")
K.nsl("gD", telescope.live_grep_directory_prompt, "Directory, Prompt")
K.nsl("gg", telescope.live_grep,                  "")
K.nsl("gi", telescope.git_grep_live_grep,         "Git Grep")
K.nsl("gh", telescope.live_grep_hidden,           "Hidden")
K.nsl("gf", telescope.live_grep_filetype_buffer,  "Filetype, Buffer")
K.nsl("gF", telescope.live_grep_filetype_prompt,  "Filetype, Prompt")
K.vsl("gg", telescope.rhs_v_grep,                 "")
K.vsl("gh", telescope.rhs_v_grep_hidden,          "Grep Hidden")
K.vsl("gi", telescope.rhs_v_git_grep_live_grep,   "Git Grep")
K.nsl("hb", ":G blame<CR>",                       "Fugitive Blame")
K.nsl("mc", dev.clean,                            "make clean")
K.nsl("mi", dev.install,                          "make install")
K.nsl("mm", dev.build,                            "make")
K.nsl("mt", dev.test,                             "make test")
K.nsl("mT", dev.test_all,                         "make test all")
K.nsl("ms", dev.source,                           "source")


--  4
--  C
--  T
--
K.nsl("+",  rainbow.toggle,                        "Toggle Rainbow")
K.nsl("cb", telescope.builtin,                     "Builtins")
K.nsl("cc", telescope.command_history,             "Command History")
K.nsl("ck", telescope.keymaps,                     "Keymaps")
K.nsl("co", telescope.commands,                    "Commands")
K.nsl("cr", telescope.resume,                      "Resume")
K.nsl("cs", telescope.search_history,              "Search History")
K.nsl("t",  "<C-]>",                               "Jump To Definition")
K.nsl("w",  "<Plug>ReplaceWithRegisterOperatoriw", "Replace Reg Inner Word")
K.xsl("w",  "<Plug>ReplaceWithRegisterVisual",     "Replace Reg Visual")
K.nsl("W",  "<Plug>ReplaceWithRegisterLine",       "Replace Reg Line")

-- ]6
--
--
--
K.n_l("r", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>", "Replace Keep")
K.n_l("R", ":%s/<C-r>=expand('<cword>')<CR>/",                            "Replace")
K.v_l("r", '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>',          "Replace Keep")
K.v_l("R", '"*y:%s/<C-r>=getreg("*")<CR>/',                               "Replace")
K.nsl("n", "<C-]>",                                                       "Definition")
K.nsl("v", ":put<CR>'[v']=",                                              "Put Format")
K.nsl("V", ":put!<CR>'[v']=",                                             "Put Above Format")

--
--
-- sS
--  Z
K.n_l("!", ": <C-r>=expand('%:.')<CR><Home>",  "Command Relative Filename")
K.v_l("!", '"*y: <C-r>=getreg("*")<CR><Home>', "Command Visual")
K.n_l("8", ": <C-r>=expand('%:p')<CR><Home>",  "Command Absolute Filename")
K.nsl("l", buffers.toggle_list,                "Toggle List")
K.nsl("L", buffers.trim_whitespace,            "Trim Whitespace")
K.nsl("z", dev.format,                         "Format")

--  `
--
--
--  |
K.n__("#",  "<Plug>(asterisk-z#)",                                             "Word Backwards Stay")
K.n_l("#",  "#",                                                               "Word Backwards")
K.n_l("/",  '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', "Spectre Word")
K.n_l("?",  '<cmd>lua require("spectre").open()<CR>',                          "Spectre")
K.v_l("/",  '<esc><cmd>lua require("spectre").open_visual()<CR>',              "Spectre Visual")
K.nsl("-",  buffers.wipe_all,                                                  "Wipe All Buffers")
K.nsl("_",  ":silent BW!<CR>",                                                 "Wipe Buffer")
K.nsl("\\", which_key.show,                                                    "Show WhichKey")

--
-- commands
--

uc("CD",     env.cd,                  {})
uc("PS",     "PackerSync",            {})
uc("S",      buffers.exec_to_buffer,  { nargs = "+", complete = "expression" })
uc("TSBase", treesitter.install_base, {})

---
--- snippets
--- gh enters select mode
---

-- remove overloaded jumps from /usr/share/nvim/runtime/lua/vim/_defaults.lua
vim.keymap.del({ "i", "s", }, "<Tab>")
vim.keymap.del({ "i", "s", }, "<S-Tab>")

local function snippet_jump(direction)
  if not snippet or not snippet._session then
    return
  end

  -- don't jump beyond the last of the tabstops and wrap forwards
  if direction == 1 and snippet._session.current_tabstop.index == table.maxn(snippet._session.tabstops) then
    while snippet._session.current_tabstop.index > 1 do
      vim.snippet.jump(-1)
    end
    return
  end

  -- wrap backwards
  if direction == -1 and snippet._session.current_tabstop.index == 1 then
    while snippet._session.current_tabstop.index < table.maxn(snippet._session.tabstops) do
      vim.snippet.jump(1)
    end
    return
  end

  -- regular jump
  vim.snippet.jump(direction)
end

-- use simple jumps that don't feed keys
vim.keymap.set({ "n", "i", "s" }, "<C-Tab>",   function() snippet_jump(1) end,  { expr = true, })
vim.keymap.set({ "n", "i", "s" }, "<C-S-Tab>", function() snippet_jump(-1) end, { expr = true, })

---
--- omni completion
---
-- TODO <BS> closes PUM, bug: https://github.com/neovim/neovim/issues/30723
-- maybe workaround as per https://github.com/neovim/neovim/blob/2d11b981bfbb7816d88a69b43b758f3a3f515b96/runtime/lua/vim/_editor.lua#L1174

K.i__("<C-space>", "<C-x><C-o>", "Omnifunc")
-- TODO add util.K
vim.keymap.set("i", "<CR>",    function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>" end,    { remap = false, expr = true })
vim.keymap.set("i", "<Tab>",   function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end,   { remap = false, expr = true })
vim.keymap.set("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { remap = false, expr = true })

return M
