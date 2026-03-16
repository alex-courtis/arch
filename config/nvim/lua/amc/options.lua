-- prevent netrw from loading
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- skip unwanted health checks
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- set the title string early to avoid flashing from async update
vim.o.titlestring = vim.fn.fnamemodify(vim.loop.cwd() or "", ":~")

-- general options
vim.o.autowriteall = true
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

-- legacy environment variables
vim.env.MANWIDTH = 80

-- clear the right-click mouse help
vim.cmd.aunmenu("PopUp.How-to\\ disable\\ mouse")
vim.cmd.aunmenu("PopUp.-2-")

-- linux console has limited capabilities
if vim.env.TERM:match("^linux") then
  return
end

-- external clipboard
vim.o.clipboard = "unnamedplus"

-- use osc when remoting or not under a compositor, otherwise let it autodetect
if vim.env.SSH_CONNECTION or not vim.env.WAYLAND_DISPLAY then
  vim.g.clipboard = "osc52"
  -- TODO remove schedule at 0.12 as https://github.com/neovim/neovim/issues/17832 has been fixed
  vim.schedule(function() vim.notify("vim.g.clipboard=" .. vim.g.clipboard, vim.log.levels.WARN) end)
end
