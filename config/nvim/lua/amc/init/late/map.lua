local require = require("amc.require").or_empty

local env = require("amc.env")
local dev = require("amc.dev")
local buffers = require("amc.buffers")
local windows = require("amc.windows")
local util = require("amc.util")

local fugitive = require("amc.plugins.fugitive")
local lsp = require("amc.plugins.lsp")
local rainbow = require("amc.plugins.rainbow")
local spectre = require("amc.plugins.spectre")
local telescope = require("amc.plugins.telescope")

local treesitter = require("amc.plugins.treesitter")
local which_key = require("amc.plugins.which-key")

local M = {}

-- escape a string for vim regex search, escaping most from pattern.txt with magic on
local pattern_escape = "/*^$.*~\\\\"
local cword_escape = "<C-r>=escape(expand('<cword>'), '" .. pattern_escape .. "')<CR>"
local reg_star_escape = "<C-r>=escape(getreg('*'), '" .. pattern_escape .. "')<CR>"

--
-- unused and available normal, leaders commented below
-- T F
-- & { } ( + ) ` - _ \ |
--

---nil safe wrapper around vim.api.nvim_create_user_command()
---@param name string
---@param command any
---@param opts vim.api.keyset.user_command
local function uc(name, command, opts)
  if command then
    vim.api.nvim_create_user_command(name, command, opts)
  end
end

local K = util.K

-- normal mode escape clears highlight
K.n___("<Esc>", function()
  vim.cmd.nohlsearch()
  vim.api.nvim_feedkeys(util.ESC, "n", false)
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
-- left, free leaders commented
--
K.n___(";",     ":",                             ":")
K.v___(";",     ":",                             ":")

K.ns__("ys",    ':let @+ = expand("%:p")<CR>',   "Yank Absolute Path")
K.ns__("yc",    ":let @+ = getcwd()<CR>",        "Yank cwd")
K.ns__("yd",    ':let @+ = expand("%:p:h")<CR>', "Yank dirname")
K.ns__("yn",    ':let @+ = expand("%:t")<CR>',   "Yank basename")
K.ns__("yr",    ':let @+ = expand("%:.")<CR>',   "Yank Relative Path")

K.c___("<C-j>", "<Down>",                        "<Down>")
K.c___("<C-k>", "<Up>",                          "<Up>")

-- [7
-- :
--
--
K.nsl_(";", windows.focus_outline,               "Outline: Open Focus")
K.nsl_("a", windows.focus_nvim_tree,             "nvim-tree: Focus")
K.nsl_("A", windows.focus_nvim_tree_update_root, "nvim-tree: Focus Update Root")
K.nsl_("'", windows.close_inc,                   "Close Lowest Window")
K.nsl_('"', vim.cmd.only,                        "Only")

--  5
--
--  O
--  {
K.ns__(",c", telescope.rhs_n_grep_cword,           "Live Grep: <cword>")
K.ns__(",d", telescope.live_grep_directory_buffer, "Live Grep: Directory, Buffer")
K.ns__(",D", telescope.live_grep_directory_prompt, "Live Grep: Directory, Prompt")
K.ns__(",,", telescope.live_grep,                  "Live Grep")
K.ns__(",i", telescope.git_grep_live_grep,         "Live Grep: Git")
K.ns__(",h", telescope.live_grep_hidden,           "Live Grep: Hidden")
K.ns__(",f", telescope.live_grep_filetype_buffer,  "Live Grep: Filetype, Buffer")
K.ns__(",F", telescope.live_grep_filetype_prompt,  "Live Grep: Filetype, Prompt")
K.vs__(",,", telescope.rhs_v_grep,                 "Live Grep")
K.vs__(",c", telescope.rhs_v_grep,                 "Live Grep")
K.vs__(",h", telescope.rhs_v_grep_hidden,          "Live Grep: Hidden")
K.vs__(",i", telescope.rhs_v_git_grep_live_grep,   "Live Grep: Git")
K.nsl_("<",  fugitive.open_only,                   "Open Only Fugitive")
K.nsl_(",",  fugitive.open,                        "Open Fugitive")
K.nsl_("o",  windows.go_home_or_next,              "Home Or Next Window")
K.nsl_("q",  windows.close,                        "Close Window")

-- }3
--  >
--  E
--  J
K.nsl_(".", lsp.next_diagnostic, "Next Diagnostic")
K.nsl_("e", windows.cnext,       "Next QF")
-- j gitsigns

-- (1
--  P
--  U
--  K
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
-- right, free leaders commented
--

--  0
--  fF
--  D
--
K.ns__("ff", telescope.find_files,        "Find Files")
K.ns__("fg", telescope.git_files,         "Find Files: Git")
K.ns__("fh", telescope.find_files_hidden, "Find Files: Hidden")
K.ns__("fo", telescope.oldfiles,          "Find Files: Previously Open")
K.n___("F",  "<Nop>",                     "<Nop>")
K.nsl_("f",  "<Nop>",                     "<Nop>")
K.nsl_("b",  ":%y<CR>",                   "Yank Buffer")
K.nsl_("B",  ":%d_<CR>",                  "Clean Buffer")

--  )2
--  gG
--  H
--  M
K.nsl_("g",  "<Nop>",            "<Nop>")
K.nsl_("hb", ":G blame<CR>",     "Fugitive: Blame")
K.nsl_("hl", ":GcLog!<CR>",      "Fugitive: :GcLog!")
K.nsl_("mc", dev.clean,          "make clean")
K.nsl_("mi", dev.install,        "make install")
K.nsl_("mm", dev.build,          "make")
K.nsl_("mt", dev.test,           "make test")
K.nsl_("mT", dev.test_all,       "make test all")
K.nsl_("ms", dev.source_scratch, ":S source")
K.nsl_("mS", dev.source,         ":source")


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
K.n___("t",  "<C-]>",                               "Tag",                        { remap = true }) -- overridden by lsp
K.n___("T",  "<C-]>",                               "Tag",                        { remap = true }) -- keep this as a backup for misbehaving lua
K.nsl_("t",  "<Nop>",                               "<Nop>")
K.nsl_("w",  "<Plug>ReplaceWithRegisterOperatoriw", "Replace Reg Inner Word")
K.vsl_("w",  "<Plug>ReplaceWithRegisterVisual",     "Replace Reg Visual")
K.nsl_("W",  "<Plug>ReplaceWithRegisterLine",       "Replace Reg Line")

-- ]6
--
--
--
K.n_l_("r", ":%s/" .. cword_escape .. "/" .. cword_escape,           "Replace Keep")
K.n_l_("R", ":%s/" .. cword_escape .. "/",                           "Replace")
K.v_l_("r", "\"*y:%s/" .. reg_star_escape .. "/" .. reg_star_escape, "Replace Keep")
K.v_l_("R", "\"*y:%s/" .. reg_star_escape .. "/",                    "Replace")
K.nsl_("n", "<C-]>",                                                 "Tag",              { remap = true }) -- overridden by lsp
K.nsl_("N", "<C-]>",                                                 "Tag",              { remap = true }) -- overridden by lsp
K.nsl_("v", ":put<CR>'[v']=",                                        "Put Format")
K.nsl_("V", ":put!<CR>'[v']=",                                       "Put Above Format")

--
--
--
--  Z
K.n_l_("!", ": <C-r>=expand('%:.')<CR><Home>",  "Command Relative Filename")
K.v_l_("!", '"*y: <C-r>=getreg("*")<CR><Home>', "Command Visual")
K.n_l_("8", ": <C-r>=expand('%:p')<CR><Home>",  "Command Absolute Filename")
K.nsl_("l", buffers.toggle_list,                "Toggle List")
K.nsl_("L", buffers.trim_whitespace,            "Trim Whitespace")
K.n_l_("s", spectre.open_cword_keep,            "Spectre cword Keep")
K.n_l_("S", spectre.open_cword,                 "Spectre cword")
K.v_l_("s", spectre.open_visual_keep,           "Spectre Visual Keep")
K.v_l_("S", spectre.open_visual,                "Spectre Visual Keep")
K.nsl_("z", dev.format,                         "Format")

--  `
--
--
--  |
K.n_l_("/",  "/<C-r>=escape(expand('<cword>'), '" .. pattern_escape .. "')<CR><Esc>",    "Search")
K.v_l_("/",  "\"*y<Esc>/<C-r>=escape(getreg('*'), '" .. pattern_escape .. "')<CR><Esc>", "Search Visual")
K.nsl_("_",  buffers.wipe_all,                                                           "Wipe All Buffers")
K.nsl_("-",  ":silent BW!<CR>",                                                          "Wipe Buffer")
K.nsl_("\\", which_key.show,                                                             "Show WhichKey")
K.vsl_("\\", which_key.show,                                                             "Show WhichKey")
K.nsl_("|",  which_key.show_local,                                                       "Show WhichKey Local")
K.vsl_("|",  which_key.show_local,                                                       "Show WhichKey Local")

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

-- don't let the signature help intrude
K.s___("<C-S>",
  function() vim.lsp.buf.signature_help({ focusable = false, close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre", "ModeChanged", } }) end,
  "Signature Help (Quiet)")

-- clear snippets
K.n_l_("dc", vim.snippet.stop, "Stop Snippets")

--
-- commands
--

uc("CD",     env.cd,                  {})
uc("S",      buffers.exec_to_buffer,  { nargs = "+", complete = "expression" })
uc("TSBase", treesitter.install_base, {})

if vim.fn.has("nvim-0.12") == 1 then
  uc("PS", function() vim.pack.update() end, {})
else
  uc("PS", "PackerSync", {})
end

return M
