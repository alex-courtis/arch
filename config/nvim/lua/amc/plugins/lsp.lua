local M = {}

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not lspconfig_ok or not cmp_nvim_lsp_ok then
  return M
end

local start_client_flags = {
  debounce_text_changes = 500,
}

lspconfig.ccls.setup({
  flags = start_client_flags,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  root_dir = lspconfig and lspconfig.util.root_pattern(".ccls", "build/compile_commands.json") or nil,
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

local config_jsonls = {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}
config_jsonls.capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.jsonls.setup(config_jsonls)

lspconfig.lua_ls.setup({
  flags = start_client_flags,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = {
          "vim",
        },
        neededFileStatus = {
          ["ambiguity-1"] = "Any",
          ["assign-type-mismatch"] = "Any",
          ["await-in-sync"] = "Any",
          ["cast-local-type"] = "Any",
          ["cast-type-mismatch"] = "Any",
          ["circle-doc-class"] = "Any",
          ["close-non-object"] = "Any",
          ["code-after-break"] = "Any",
          ["codestyle-check"] = "None",
          ["count-down-loop"] = "Any",
          ["deprecated"] = "Any",
          ["different-requires"] = "Any",
          ["discard-returns"] = "Any",
          ["doc-field-no-class"] = "Any",
          ["duplicate-doc-alias"] = "Any",
          ["duplicate-doc-field"] = "Any",
          ["duplicate-doc-param"] = "Any",
          ["duplicate-index"] = "Any",
          ["duplicate-set-field"] = "Any",
          ["empty-block"] = "Any",
          ["global-in-nil-env"] = "Any",
          ["lowercase-global"] = "Any",
          ["missing-parameter"] = "Any",
          ["missing-return"] = "Any",
          ["missing-return-value"] = "Any",
          ["need-check-nil"] = "Any",
          ["newfield-call"] = "Any",
          ["newline-call"] = "Any",
          ["no-unknown"] = "None",
          ["not-yieldable"] = "Any",
          ["param-type-mismatch"] = "Any",
          ["redefined-local"] = "Any",
          ["redundant-parameter"] = "Any",
          ["redundant-return"] = "Any",
          ["redundant-return-value"] = "Any",
          ["redundant-value"] = "Any",
          ["return-type-mismatch"] = "Any",
          ["spell-check"] = "None",
          ["trailing-space"] = "Any",
          ["unbalanced-assignments"] = "Any",
          ["undefined-doc-class"] = "Any",
          ["undefined-doc-name"] = "Any",
          ["undefined-doc-param"] = "Any",
          ["undefined-env-child"] = "Any",
          ["undefined-field"] = "Any",
          ["undefined-global"] = "Any",
          ["unknown-cast-variable"] = "Any",
          ["unknown-diag-code"] = "Any",
          ["unknown-operator"] = "Any",
          ["unreachable-code"] = "Any",
          ["unused-function"] = "Any",
          ["unused-label"] = "Any",
          ["unused-local"] = "Any",
          ["unused-vararg"] = "Any",
        },
      },
      semantic = {
        -- ugly and takes time to set
        variable = false,
      },
    },
  },
})

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})

lspconfig.zls.setup({
  flags = start_client_flags,
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

function M.goto_definition_or_tag()
  vim.fn.settagstack(vim.fn.win_getid(), { items = {} })

  if vim.fn.has("nvim-0.10") == 1 then
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      if client.server_capabilities.definitionProvider then
        vim.lsp.buf.definition()
        return
      end
    end
  elseif vim.lsp.buf.server_ready() then
    vim.lsp.buf.definition()
    return
  end

  local cmd = vim.api.nvim_replace_termcodes("normal <C-]>", true, true, true)
  local ok, err = pcall(function()
    return vim.cmd(cmd)
  end)
  if not ok then
    vim.api.nvim_notify(err, vim.log.levels.WARN, {})
  end
end

function M.goto_prev()
  local opts = { wrap = false }
  vim.diagnostic.goto_prev(opts)
end

function M.goto_next()
  local opts = { wrap = false }
  vim.diagnostic.goto_next(opts)
end

-- init

return M
