filetype off
call vundle#begin("~/.local/share/nvim/vundle")

Plugin 'ckipp01/stylua-nvim'
Plugin 'echasnovski/mini.base16'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'hashivim/vim-terraform'
Plugin 'hrsh7th/cmp-buffer'
Plugin 'hrsh7th/cmp-cmdline'
Plugin 'hrsh7th/cmp-nvim-lsp'
Plugin 'hrsh7th/cmp-path'
Plugin 'hrsh7th/cmp-vsnip'
Plugin 'hrsh7th/nvim-cmp'
Plugin 'hrsh7th/vim-vsnip'
Plugin 'lewis6991/gitsigns.nvim'
Plugin 'neovim/nvim-lspconfig'
Plugin 'nvim-lua/plenary.nvim'
Plugin 'nvim-lualine/lualine.nvim'
Plugin 'nvim-telescope/telescope.nvim'
Plugin 'nvim-tree/nvim-tree.lua'
Plugin 'nvim-tree/nvim-web-devicons'
Plugin 'qpkorr/vim-bufkill'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'xorid/asciitree.nvim'
Plugin 'ziglang/zig.vim'

" plugin and coc-settings.json retained for coc replications
" Plugin 'neoclide/coc.nvim'

call vundle#end()
filetype plugin indent on

runtime keys.vim

" put the results of a silent command in " and +
command -nargs=+ C redir @" | silent exec <q-args> | redir end | let @+ = @"

" reset mouse
command MR set mouse= | set mouse=a

" clear macros; can't persist emtpy macro so 0 will do
command MC for i in range(char2nr('a'), char2nr('z')) | call setreg(nr2char(i), "0") | endfor | unlet i

" "init.lua"
lua require('amc.init')


" event order matters
autocmd BufLeave * ++nested silent! update
autocmd DirChanged global call amc#updatePath()
autocmd FocusLost * ++nested silent! update
autocmd VimEnter * call amc#startupCwd()

