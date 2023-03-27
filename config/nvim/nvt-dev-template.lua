vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.cursorline = true

vim.o.packpath = "/tmp/nvt-dev/site"
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
  "nvim-tree/nvim-web-devicons",
  -- 'nvim-tree/nvim-tree.lua',
  -- NVIM_TREE_DIR
})

if bootstrapping then
  vim.api.nvim_create_autocmd({ "User PackerComplete" }, {
    callback = function()
      vim.cmd.exit()
    end,
  })

  packer.sync()
  return
end

local api = require("nvim-tree.api")

-- stylua: ignore start
vim.keymap.set("n", ";",        ":",                                   { noremap = true })
vim.keymap.set("n", "<space>a", function() api.tree.open({}) end,      { noremap = true })
vim.keymap.set("n", "<space>'", function() api.tree.find_file({}) end, { noremap = true })
vim.keymap.set("n", "<space>o", "wincmd p",                            { noremap = true })
-- stylua: ignore end

local function on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- stylua: ignore start
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  -- stylua: ignore end
end

require("nvim-tree").setup({
  -- DEFAULT_OPTS
})
