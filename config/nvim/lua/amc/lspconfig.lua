local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

lspconfig.ccls.setup({
  on_attach = on_attach,
  init_options = {
    compilationDatabaseDirectory = "build",
    clang = {
      excludeArgs = { "-Werror" },
    },
  },
})
