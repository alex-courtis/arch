local require = require("amc.require_or_nil")

local M = {}

local dev = require("amc.dev") or {}

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local telescope = require("amc.plugins.telescope") or {}

if not lspconfig then
  return M
end

---
--- Global config
---
vim.diagnostic.config({
  signs = false,
  severity_sort = true, -- error before warn on virtual text
}, nil)

---
--- Base Capabilities
---
---@type lsp.ClientCapabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

---
--- Common Flags
---
---@type vim.lsp.Client.Flags
local flags = {
  debounce_text_changes = 500,
  exit_timeout = false,
}

---
--- Completion
---
if cmp_nvim_lsp then
  -- hrsh7th/cmp-nvim-lsp helper adds lsp capabilities for hrsh7th/nvim-cmp
  capabilities.textDocument.completion = cmp_nvim_lsp.default_capabilities().textDocument.completion
end

---
--- Map
---
--- @param bufnr number
--- @param client vim.lsp.Client
local function on_attach(client, bufnr)
  pcall(vim.keymap.del, "n", "K", { buffer = bufnr })

  for _, leader in ipairs({ "<space>", "<bs>" }) do
    if client.server_capabilities.definitionProvider then
      vim.keymap.set("n", leader .. "t", vim.lsp.buf.definition, { buffer = bufnr })
    end
    if client.server_capabilities.declarationProvider then
      vim.keymap.set("n", leader .. "T", vim.lsp.buf.declaration, { buffer = bufnr })
    end

    vim.keymap.set("n", leader .. "n", telescope.lsp_references, { buffer = bufnr })

    vim.keymap.set("n", leader .. "da", vim.lsp.buf.code_action,   { buffer = bufnr })
    vim.keymap.set("n", leader .. "dq", vim.diagnostic.setqflist,  { buffer = bufnr })
    vim.keymap.set("n", leader .. "df", vim.diagnostic.open_float, { buffer = bufnr })
    vim.keymap.set("n", leader .. "dh", vim.lsp.buf.hover,         { buffer = bufnr })
    vim.keymap.set("n", leader .. "dl", telescope.diagnostics,     { buffer = bufnr })
    vim.keymap.set("n", leader .. "dr", dev.lsp_rename,            { buffer = bufnr })
  end
end

--
-- cc
--
---@type lspconfig.Config
local ccls = {
  flags = flags,
  capabilities = capabilities,
  on_attach = on_attach,
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
}
lspconfig.ccls.setup(ccls)

--
-- json
--
---@type lspconfig.Config
local jsonls = {
  flags = flags,
  capabilities = capabilities,
  on_attach = on_attach,
}
lspconfig.jsonls.setup(jsonls)

--
-- lua
--
---@type lspconfig.Config
local luals = {
  flags = flags,
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      workspace = {
        library = {
          "$VIMRUNTIME/lua/vim",
          "${3rd}/luv/library",
        },
      },
      completion = {
        callSnippet = "Replace",
      },
      semantic = {
        -- ugly and takes time to set
        variable = false,
      },
    },
  },
}
lspconfig.lua_ls.setup(luals)

--
-- yaml
--
---@type lspconfig.Config
local yamlls = {
  flags = flags,
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
}
lspconfig.yamlls.setup(yamlls)

--
-- zig
--
---@type lspconfig.Config
local zls = {
  flags = flags,
  capabilities = capabilities,
  on_attach = on_attach,
}
lspconfig.zls.setup(zls)

function M.goto_prev()
  vim.diagnostic.goto_prev({ wrap = false })
end

function M.goto_next()
  vim.diagnostic.goto_next({ wrap = false })
end

-- init

return M
