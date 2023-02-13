vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

if bootstrapping then
  vim.api.nvim_create_autocmd({ "User PackerComplete" }, {
    callback = function()
      vim.cmd.exit()
    end,
  })

  packer.use("wbthomason/packer.nvim")
  packer.use({
    -- 'nvim-tree/nvim-tree.lua',
    -- NVIM_TREE_DIR
    "nvim-tree/nvim-web-devicons",
  })
  packer.sync()
  return
end

require("nvim-tree").setup({
  -- DEFAULT_OPTS
})

local nt_api = require("nvim-tree.api")

vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", "<space>a", nt_api.tree.open, { noremap = true })
vim.keymap.set("n", "<space>o", [[ :wincmd p<CR> ]], { noremap = true })
