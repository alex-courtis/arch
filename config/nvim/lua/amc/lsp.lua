local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")

  local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

  lspconfig.ccls.setup({
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern(".ccls", "build/compile_commands.json"),
    init_options = {
      compilationDatabaseDirectory = "build",
      clang = {
        excludeArgs = {
          "-Werror",
        },
        extraArgs = {
          -- this is often false flagged
          "-Wno-empty-translation-unit",
        },
      },
    },
  })

  lspconfig.sumneko_lua.setup({
    settings = {
      Lua = {
        diagnostics = {
          globals = {
            "vim",
          },
          disable = {
            "trailing-space",
            "redundant-parameter",
          },
        },
        workspace = {
          -- current project before runtime
          library = {
            ".",
            vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },
  })

  require("lspconfig").zls.setup({})
end

function M.goto_definition_or_tag()
  vim.fn.settagstack(vim.fn.win_getid(), { items = {} })
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.definition()
  else
    local cmd = vim.api.nvim_replace_termcodes("normal <C-]>", true, true, true)
    local ok, err = pcall(vim.cmd, cmd)
    if not ok then
      vim.api.nvim_notify(err, vim.log.levels.WARN, {})
    end
  end
end

function M.references_or_next_tag()
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.references()
  else
    local ok, err = pcall(vim.cmd, "tnext")
    if not ok then
      vim.api.nvim_notify(err, vim.log.levels.WARN, {})
    end
  end
end

function M.nothing_or_prev_tag()
  if not vim.lsp.buf.server_ready() then
    local ok, err = pcall(vim.cmd, "tprevious")
    if not ok then
      vim.api.nvim_notify(err, vim.log.levels.WARN, {})
    end
  end
end

return M
