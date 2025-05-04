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
local which_key = require("amc.plugins.which-key") or {}

local K = {}
local M = {}

-- TODO extract these for use by diagnostics, telescope etc.
---nil safe wrappers around vim.keymap.set() rhs
for _, mode in ipairs({ "n", "i", "c", "v", "x", "s", "o" }) do
  K[mode .. "m" .. "__"] = function(lhs, rhs, desc)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = false, })
    end
  end
  K[mode .. "m" .. "s_"] = function(lhs, rhs, desc)
    if rhs then
      vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = false, silent = true, })
    end
  end
  K[mode .. "m" .. "_l"] = function(lhs, rhs, desc)
    if rhs then
      for _, leader in ipairs({ "<Space>", "<BS>" }) do
        K[mode .. "m" .. "__"](leader .. lhs, rhs, desc)
      end
    end
  end
  K[mode .. "m" .. "sl"] = function(lhs, rhs, desc)
    if rhs then
      for _, leader in ipairs({ "<Space>", "<BS>" }) do
        K[mode .. "m" .. "s_"](leader .. lhs, rhs, desc)
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
K.vm__("<LeftRelease>",  '"*ygv',          "Autoselect")

K.nm__("<C-j>",          "<C-w>j")
K.nm__("<C-k>",          "<C-w>k")
K.nm__("<C-l>",          "<C-w>l")
K.nm__("<C-h>",          "<C-w>h")
K.nm__("<C-Space>",      "<C-w>w")
K.nm__("<C-S-Space>",    "<C-w>W")

K.nms_("<BS><BS>",       ":silent BB<CR>", "Prev Buffer")
K.nms_("<Space><Space>", ":silent BF<CR>", "Next Buffer")

--
-- left
--
K.nm__(";",     ":")
K.vm__(";",     ":")

K.nms_("ys",    ':let @+ = expand("%:p")<CR>', "Yank Absolute Path")
K.nms_("yc",    ":let @+ = getcwd()<CR>",      "Yank cwd")
K.nms_("yn",    ':let @+ = expand("%:t")<CR>', "Yank Name")
K.nms_("yr",    ':let @+ = expand("%:.")<CR>', "Yank Relative Path")

K.cm__("<C-j>", "<Down>")
K.cm__("<C-k>", "<Up>")

-- [7
--
--
--
K.nmsl(";", vim.cmd.copen,             "Open Quickfix")
K.nmsl(":", vim.cmd.cclose,            "Close Quickfix")
K.nmsl("a", nvt.open_find,             "Open nvim-tree Update Root")
K.nmsl("A", nvt.open_find_update_root, "Open nvim-tree")
K.nmsl("'", windows.close_inc,         "Close Lowest Window")
K.nmsl('"', windows.close_others,      "Close Other Windows")

--  5
--
--  O
--
K.nm_l("{", "[{",                    "Prev {")
K.nmsl(",", fugitive.open_only,      "Open Only Fugitive")
K.nmsl("<", fugitive.open,           "Open Fugitive")
K.nmsl("o", windows.go_home_or_next, "Home Or Next Window")
K.nmsl("q", windows.close,           "Close Window")
K.nmsl("Q", vim.cmd.only,            "Only")

--  3
--  >
--  E
--  J
K.nm_l("}", "]}",          "Next }")
K.nmsl(".", lsp.goto_next, "Next Diagnostic")
K.nmsl("e", windows.cnext, "Next QF")
-- j gitsigns

--  1
--  P
--  U
--  K
K.nm_l("(", "[(",          "Prev (")
K.nmsl("p", lsp.goto_prev, "Prev Diagnostic")
K.nmsl("u", windows.cprev, "Prev QF")
-- k gitsigns

-- =9
--  Y
--  I
--  X
K.nmsl("y", telescope.git_status, "Telescope Git Status")
K.nmsl("i", telescope.buffers,    "Telescope Buffers")
K.nmsl("x", ":silent BA<CR>",     "Alt Buffer")

--
-- right
--

--  0
-- fF
--  D
--
K.nm__("*", "<Plug>(asterisk-z*)", "Word Forwards Stay")
K.nm_l("*", "*",                   "Word Forwards")
K.nmsl("b", ":%y<CR>",             "Yank Buffer")
K.nmsl("B", ":%d_<CR>",            "Clean Buffer")

--  2
-- gG
--  H
--  M
K.nm_l(")",  "])",           "Next )")
K.nmsl("hb", ":G blame<CR>", "Fugitive Blame")
K.nmsl("mc", dev.clean,      "make clean")
K.nmsl("mi", dev.install,    "make install")
K.nmsl("mm", dev.build,      "make")
K.nmsl("mt", dev.test,       "make test")
K.nmsl("mT", dev.test_all,   "make test all")
K.nmsl("ms", dev.source,     "source")


--  4
-- cC
--  T
--
K.nmsl("+",  rainbow.toggle,                        "Toggle Rainbow")

K.nmsl("tb", telescope.builtin,                     "Builtins")
K.nmsl("tc", telescope.commands,                    "Commands")
K.nmsl("td", telescope.live_grep_directory_buffer,  "Grep In Directory Buffer")
K.nmsl("tD", telescope.live_grep_directory_prompt,  "Grep In Directory Prompt")
K.nmsl("tf", telescope.find_files,                  "Files")
K.nmsl("tF", telescope.find_files_hidden,           "Files Hidden")
K.nmsl("tg", telescope.live_grep,                   "Grep")
K.nmsl("tG", telescope.live_grep_hidden,            "Grep Hidden")
K.nmsl("th", telescope.command_history,             "Command History")
K.nmsl("ti", telescope.live_grep_filetype_buffer,   "Grep By Filetype")
K.nmsl("tI", telescope.live_grep_filetype_prompt,   "Grep By Filetype Prompt")
K.nmsl("tr", telescope.resume,                      "Resume")
K.nmsl("tw", telescope.rhs_n_grep_cword,            "Grep cword")
K.vmsl("tg", telescope.rhs_v_grep,                  "Grep")
K.vmsl("tG", telescope.rhs_v_grep_hidden,           "Grep Hidden")
K.nmsl("w",  "<Plug>ReplaceWithRegisterOperatoriw", "Replace Reg Inner Word")
K.xmsl("w",  "<Plug>ReplaceWithRegisterVisual",     "Replace Reg Visual")
K.nmsl("W",  "<Plug>ReplaceWithRegisterLine",       "Replace Reg Line")

-- ]6
--
--
--
K.nm_l("r", ":%s/<C-r>=expand('<cword>')<CR>/<C-r>=expand('<cword>')<CR>", "Replace Keep")
K.nm_l("R", ":%s/<C-r>=expand('<cword>')<CR>/",                            "Replace")
K.vm_l("r", '"*y:%s/<C-r>=getreg("*")<CR>/<C-r>=getreg("*")<CR>',          "Replace Keep")
K.vm_l("R", '"*y:%s/<C-r>=getreg("*")<CR>/',                               "Replace")
K.nmsl("n", "<C-]>",                                                       "Definition")
K.nmsl("v", ":put<CR>'[v']=",                                              "Put Format")
K.nmsl("V", ":put!<CR>'[v']=",                                             "Put Above Format")

--
--
-- sS
--  Z
K.nm_l("!", ": <C-r>=expand('%:.')<CR><Home>",  "Command Relative Filename")
K.vm_l("!", '"*y: <C-r>=getreg("*")<CR><Home>', "Command Visual")
K.nm_l("8", ": <C-r>=expand('%:p')<CR><Home>",  "Command Absolute Filename")
K.nmsl("l", buffers.toggle_list,                "Toggle List")
K.nmsl("L", buffers.trim_whitespace,            "Trim Whitespace")
K.nmsl("z", dev.format,                         "Format")

--  `
--
--
--  |
K.nm__("#",  "<Plug>(asterisk-z#)",                                             "Word Backwards Stay")
K.nm_l("#",  "#",                                                               "Word Backwards")
K.nm_l("/",  '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', "Spectre Word")
K.nm_l("?",  '<cmd>lua require("spectre").open()<CR>',                          "Spectre")
K.vm_l("/",  '<esc><cmd>lua require("spectre").open_visual()<CR>',              "Spectre Visual")
K.nmsl("-",  buffers.wipe_all,                                                  "Wipe All Buffers")
K.nmsl("_",  ":silent BW!<CR>",                                                 "Wipe Buffer")
K.nmsl("\\", which_key.show,                                                    "Show WhichKey")

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
-- commands
--

uc("CD",     env.cd,                  {})
uc("PS",     "PackerSync",            {})
uc("S",      buffers.exec_to_buffer,  { nargs = "+", complete = "expression" })
uc("TSBase", treesitter.install_base, {})

return M
