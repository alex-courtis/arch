local M = {}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.termguicolors = true

vim.opt.statusline = "b%{bufnr()} i%{win_getid()} %y %F"

vim.o.packpath = "/tmp/nd/local/share/nvim/site"
local package_root = vim.o.packpath .. "/pack"
local install_path = vim.o.packpath .. "/pack/packer/start/packer.nvim"
local compile_path = vim.o.packpath .. "/pack/packer/start/packer.nvim/plugin/packer_compiled.lua"

local bootstrapping = vim.fn.isdirectory(install_path) == 0

if bootstrapping then
  print("Bootstrapping...")
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", install_path })
end

local packer = require("packer")

packer.init({
  package_root = package_root,
  compile_path = compile_path,
})

packer.use("wbthomason/packer.nvim")
packer.use({
  "neovim/nvim-lspconfig",
  "nvim-tree/nvim-web-devicons",
  -- { "nvim-tree/nvim-tree.lua", as = "nvim-tree.lua.dev" },
  -- NVIM_TREE_DIR
})

if bootstrapping then
  vim.cmd([[
    autocmd User PackerComplete quitall
  ]])

  packer.sync()
  return
end

local api = require("nvim-tree.api")
local log = require("nvim-tree.log")

vim.keymap.set("n", ";",        ":",                                                { noremap = true })
vim.keymap.set("n", "<space>;", function() api.tree.open({}) end,                   { noremap = true })
vim.keymap.set("n", "<space>a", function() api.tree.open({ find_file = true }) end, { noremap = true })
vim.keymap.set("n", "<space>'", function() api.tree.find_file({ open = true }) end, { noremap = true })
vim.keymap.set("n", "<space>o", function() vim.cmd.wincmd("p") end,                 { noremap = true })

vim.keymap.set("n", "tn",       ":tabnew<CR>",                                      { noremap = true })
vim.keymap.set("n", "tc",       ":tabclose<CR>",                                    { noremap = true })
vim.keymap.set("n", "th",       ":tabprevious<CR>",                                 { noremap = true })
vim.keymap.set("n", "tl",       ":tabnext<CR>",                                     { noremap = true })
vim.keymap.set("n", "to",       ":tabonly<CR>",                                     { noremap = true })

function M.on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.map.on_attach.default(bufnr)

  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function(data)
    print(data.event .. " " .. data.file)
  end,
})

vim.api.nvim_create_user_command("PS", "PackerSync", {})

api.events.subscribe(api.events.Event.NodeRenamed, function(data)
  log.line("dev", "Event.NodeRenamed %s %s", data.old_name, data.new_name)
end)

vim.cmd([[
:hi NvimTreeRootFolder guifg=magenta
]])

vim.lsp.enable("lua_ls")

---@type nvim_tree.config
local config = {
  -- config-default-injection-placeholder
}

require("nvim-tree").setup(config)

return M
