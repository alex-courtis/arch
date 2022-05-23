local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")

  local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

  lspconfig.ccls.setup({
    capabilities = capabilities,
    init_options = {
      compilationDatabaseDirectory = "build",
      clang = {
        excludeArgs = {
          "-Werror",
        },
      },
    },
  })

  lspconfig.sumneko_lua.setup({
    settings = {
      Lua = {
        diagnostics = {
          -- ignore vim global, for which there are no definitions
          globals = {'vim'},
        },
        workspace = {
          -- current project before runtime
          library = {
            '.',
            vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },
  })
end

function M.goto_definition_or_tag()
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.definition()
  else
    vim.fn.settagstack(vim.fn.win_getid(), { items = {} })
    vim.cmd(vim.api.nvim_replace_termcodes('normal <C-]>', true, true, true))
  end
end

function M.references_or_next_tag()
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.references()
  else
    vim.cmd("silent! tn")
  end
end

return M

