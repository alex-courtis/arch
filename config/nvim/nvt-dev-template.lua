vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.cursorline = true

local opts = { noremap = true }
-- stylua: ignore start
vim.keymap.set("n", ";",        ":",                                                 opts)
vim.keymap.set("n", "<space>a", function() require("nvim-tree.api").tree.open() end, opts)
vim.keymap.set("n", "<space>o", function() vim.cmd.wincmd("p") end                 , opts)
-- stylua: ignore end

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
