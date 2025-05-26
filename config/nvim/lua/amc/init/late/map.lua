local require = require("amc.require").or_empty

local env = require("amc.env")
local dev = require("amc.dev")
local buffers = require("amc.buffers")
local windows = require("amc.windows")
local K = require("amc.util").K

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
K.n___("<Esc>", function()
  vim.cmd.nohlsearch()
  vim.api.nvim_feedkeys(ESC, "n", false)
end, ":nohlsearch <Esc>")

-- hacky vim clipboard=autoselect https://github.com/neovim/neovim/issues/2325
K.v___("<LeftRelease>",  '"*ygv',          "Autoselect")

K.n___("<C-j>",          "<C-w>j",         "<C-w>j")
K.n___("<C-k>",          "<C-w>k",         "<C-w>k")
K.n___("<C-l>",          "<C-w>l",         "<C-w>l")
K.n___("<C-h>",          "<C-w>h",         "<C-w>h")
K.n___("<C-Space>",      "<C-w>w",         "<C-w>w")
K.n___("<C-S-Space>",    "<C-w>W",         "<C-w>W")

K.ns__("<BS><BS>",       ":silent BB<CR>", "Prev Buffer")
K.ns__("<Space><Space>", ":silent BF<CR>", "Next Buffer")

--
-- left
--
K.n___(";",     ":",                           ":")
K.v___(";",     ":",                           ":")

K.ns__("ys",    ':let @+ = expand("%:p")<CR>', "Yank Absolute Path")
K.ns__("yc",    ":let @+ = getcwd()<CR>",      "Yank cwd")
K.ns__("yn",    ':let @+ = expand("%:t")<CR>', "Yank Name")
K.ns__("yr",    ':let @+ = expand("%:.")<CR>', "Yank Relative Path")

K.c___("<C-j>", "<Down>",                      "<Down>")
K.c___("<C-k>", "<Up>",                        "<Up>")

-- [7
--
--
--
K.nsl_(";", vim.cmd.copen,             "Open Quickfix")
K.nsl_(":", vim.cmd.cclose,            "Close Quickfix")
K.nsl_("a", nvt.open_find,             "Open nvim-tree")
K.nsl_("A", nvt.open_find_update_root, "Open nvim-tree Update Root")
K.nsl_("'", windows.close_inc,         "Close Lowest Window")
K.nsl_('"', windows.close_others,      "Close Other Windows")

--  5
--
--  O
--
K.n_l_("{", "[{",                    "Prev {")
K.nsl_(",", fugitive.open_only,      "Open Only Fugitive")
K.nsl_("<", fugitive.open,           "Open Fugitive")
K.nsl_("o", windows.go_home_or_next, "Home Or Next Window")
K.nsl_("q", windows.close,           "Close Window")
K.nsl_("Q", vim.cmd.only,            "Only")

--  3
--  >
--  E
--  J
K.n_l_("}", "]}",                "Next }")
K.nsl_(".", lsp.next_diagnostic, "Next Diagnostic")
K.nsl_("e", windows.cnext,       "Next QF")
-- j gitsigns

--  1
--  P
--  U
--  K
K.n_l_("(", "[(",                "Prev (")
K.nsl_("p", lsp.prev_diagnostic, "Prev Diagnostic")
K.nsl_("u", windows.cprev,       "Prev QF")
-- k gitsigns

-- =9
--  Y
--  I
--  X
K.nsl_("y", telescope.git_status, "Dirty Buffers")
K.nsl_("i", telescope.buffers,    "Open Buffers")
K.nsl_("x", ":silent BA<CR>",     "Alt Buffer")

--
-- right
--

--  0
--  F
--  D
--
K.n___("*",  "<Plug>(asterisk-z*)",       "Word Forwards Stay")
K.n_l_("*",  "*",                         "Word Forwards")
K.nsl_("ff", telescope.find_files,        "Find Files")
K.nsl_("fg", telescope.git_files,         "Find Files: Git")
K.nsl_("fh", telescope.find_files_hidden, "Find Files: Hidden")
K.nsl_("fo", telescope.oldfiles,          "Find Files: Previously Open")
K.nsl_("b",  ":%y<CR>",                   "Yank Buffer")
K.nsl_("B",  ":%d_<CR>",                  "Clean Buffer")

--  2
--  G
--  H
--  M
K.n_l_(")",  "])",                                 "Next )")
K.nsl_("gc", telescope.rhs_n_grep_cword,           "Live Grep: <cword>")
K.nsl_("gd", telescope.live_grep_directory_buffer, "Live Grep: Directory, Buffer")
K.nsl_("gD", telescope.live_grep_directory_prompt, "Live Grep: Directory, Prompt")
K.nsl_("gg", telescope.live_grep,                  "Live Grep")
K.nsl_("gi", telescope.git_grep_live_grep,         "Live Grep: Git")
K.nsl_("gh", telescope.live_grep_hidden,           "Live Grep: Hidden")
K.nsl_("gf", telescope.live_grep_filetype_buffer,  "Live Grep: Filetype, Buffer")
K.nsl_("gF", telescope.live_grep_filetype_prompt,  "Live Grep: Filetype, Prompt")
K.vsl_("gg", telescope.rhs_v_grep,                 "Live Grep")
K.vsl_("gh", telescope.rhs_v_grep_hidden,          "Live Grep: Hidden")
K.vsl_("gi", telescope.rhs_v_git_grep_live_grep,   "Live Grep: Git")
K.nsl_("hb", ":G blame<CR>",                       "Fugitive: Blame")
K.nsl_("mc", dev.clean,                            "make clean")
K.nsl_("mi", dev.install,                          "make install")
K.nsl_("mm", dev.build,                            "make")
K.nsl_("mt", dev.test,                             "make test")
K.nsl_("mT", dev.test_all,                         "make test all")
K.nsl_("ms", dev.source,                           ":source")


--  4
--  C
--  T
--
K.nsl_("+",  rainbow.toggle,                        "Toggle Rainbow")
K.nsl_("cb", telescope.builtin,                     "Telescope: Builtins")
K.nsl_("cc", telescope.command_history,             "Telescope: Command History")
K.nsl_("ck", telescope.keymaps,                     "Telescope: Keymaps")
K.nsl_("co", telescope.commands,                    "Telescope: Commands")
K.nsl_("cr", telescope.resume,                      "Telescope: Resume")
K.nsl_("cs", telescope.search_history,              "Telescope: Search History")
K.nsl_("t",  "<C-]>",                               "Jump To Definition")
K.nsl_("w",  "<Plug>ReplaceWithRegisterOperatoriw", "Replace Reg Inner Word")
K.vsl_("w",  "<Plug>ReplaceWithRegisterVisual",     "Replace Reg Visual")
K.nsl_("W",  "<Plug>ReplaceWithRegisterLine",       "Replace Reg Line")

-- ]6
--
--
--
K.n_l_("r", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>", "Replace Keep")
K.n_l_("R", ":%s/<C-r>=expand('<cword>')<CR>/",                            "Replace")
K.v_l_("r", '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>',          "Replace Keep")
K.v_l_("R", '"*y:%s/<C-r>=getreg("*")<CR>/',                               "Replace")
K.nsl_("n", "<C-]>",                                                       "Definition")
K.nsl_("v", ":put<CR>'[v']=",                                              "Put Format")
K.nsl_("V", ":put!<CR>'[v']=",                                             "Put Above Format")

--
--
-- sS
--  Z
K.n_l_("!", ": <C-r>=expand('%:.')<CR><Home>",  "Command Relative Filename")
K.v_l_("!", '"*y: <C-r>=getreg("*")<CR><Home>', "Command Visual")
K.n_l_("8", ": <C-r>=expand('%:p')<CR><Home>",  "Command Absolute Filename")
K.nsl_("l", buffers.toggle_list,                "Toggle List")
K.nsl_("L", buffers.trim_whitespace,            "Trim Whitespace")
K.nsl_("z", dev.format,                         "Format")

--  `
--
--
--  |
K.n___("#",  "<Plug>(asterisk-z#)",                                             "Word Backwards Stay")
K.n_l_("#",  "#",                                                               "Word Backwards")
K.n_l_("/",  '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', "Spectre Word")
K.n_l_("?",  '<cmd>lua require("spectre").open()<CR>',                          "Spectre")
K.v_l_("/",  '<esc><cmd>lua require("spectre").open_visual()<CR>',              "Spectre Visual")
K.nsl_("-",  buffers.wipe_all,                                                  "Wipe All Buffers")
K.nsl_("_",  ":silent BW!<CR>",                                                 "Wipe Buffer")
K.nsl_("\\", which_key.show,                                                    "Show WhichKey")
K.nsl_("|",  which_key.show_local,                                              "Show WhichKey Local")

---
--- snippets
--- gh enters select mode
---

-- remove overloaded jumps from /usr/share/nvim/runtime/lua/vim/_defaults.lua
vim.keymap.del({ "i", "s", }, "<Tab>")
vim.keymap.del({ "i", "s", }, "<S-Tab>")

-- use simple jumps that don't feed keys
K.n___("<C-Tab>",   lsp.next_snippet, "Prev Snippet", { expr = true, })
K.i___("<C-Tab>",   lsp.next_snippet, "Prev Snippet", { expr = true, })
K.s___("<C-Tab>",   lsp.next_snippet, "Prev Snippet", { expr = true, })
K.n___("<C-S-Tab>", lsp.prev_snippet, "Next Snippet", { expr = true, })
K.i___("<C-S-Tab>", lsp.prev_snippet, "Next Snippet", { expr = true, })
K.s___("<C-S-Tab>", lsp.prev_snippet, "Next Snippet", { expr = true, })

---
--- omni completion
---
-- TODO <BS> closes PUM, bug: https://github.com/neovim/neovim/issues/30723
-- maybe workaround as per https://github.com/neovim/neovim/blob/2d11b981bfbb7816d88a69b43b758f3a3f515b96/runtime/lua/vim/_editor.lua#L1174

-- open PUM or select next
K.i___("<C-space>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-x><C-o>" end, "Omnicomplete", { expr = true })

-- navigate and select
K.i___("<CR>",    function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>" end,    "Accept Match", { expr = true })
K.i___("<Tab>",   function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end,   "Next Match",   { expr = true })
K.i___("<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, "Prev Match",   { expr = true })

--
-- commands
--

uc("CD",     env.cd,                  {})
uc("PS",     "PackerSync",            {})
uc("S",      buffers.exec_to_buffer,  { nargs = "+", complete = "expression" })
uc("TSBase", treesitter.install_base, {})

return M
