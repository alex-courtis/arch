-- prevent netrw from loading
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- general options
vim.o.autowriteall = true
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.cursorline = true
vim.o.history = 500 -- applies to shada
vim.o.ignorecase = true
vim.o.listchars = vim.o.listchars .. ",space:·"
vim.o.mouse = "a"
vim.o.number = true
vim.o.pumheight = 15
vim.o.pumwidth = 30
vim.o.shiftwidth = 4
vim.o.shortmess = vim.o.shortmess .. "S" -- no search count
vim.o.showcmd = false
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.switchbuf = "useopen,uselast"
vim.o.tabstop = 4
vim.o.tags = "**/tags"
vim.o.title = true
vim.o.undofile = true
vim.o.wrapscan = false

-- error format
vim.o.errorformat = "%.%#[   LINE   ] --- %f:%l:%m," .. vim.o.errorformat -- cmocka
vim.o.errorformat = "make%.%#: *** [%f:%l:%m," .. vim.o.errorformat       -- errors in makefiles themselves

-- legacy plugin options
vim.g["asterisk#keeppos"] = 1
vim.g.BufKillCreateMappings = 0
vim.g.zig_build_makeprg_params = "-Dxwayland --prefix ~/.local install"

-- legacy environment variables
vim.env.MANWIDTH = 80
