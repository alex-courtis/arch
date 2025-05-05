local M = {}

local require = require("amc.require").or_empty

local dev = require("amc.dev")
local telescope = require("amc.plugins.telescope")

require = require("amc.require").or_nil

--
-- TODO move to vim.lsp.config and vim.lsp.completion
--

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

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

  -- see :help lsp-defaults
  pcall(vim.keymap.del, "n", "K", { buffer = bufnr })

  for _, leader in ipairs({ "<space>", "<bs>" }) do

    -- no need to rebind c-]
    -- vim.lsp.tagfunc() indicates that it calls textDocument/definition,
    -- however vim.lsp.buf.definition returns two results e.g. wk.Spec
    if client.server_capabilities.definitionProvider then
      -- vim.keymap.set("n", leader .. "t",  vim.lsp.buf.definition, { buffer = bufnr, desc = "vim.lsp.buf.definition", })
      vim.keymap.set("n", leader .. "dt", vim.lsp.buf.definition, { buffer = bufnr, desc = "vim.lsp.buf.definition", })
    end

    if client.server_capabilities.declarationProvider then
      vim.keymap.set("n", leader .. "T",  vim.lsp.buf.declaration, { buffer = bufnr, desc = "vim.lsp.buf.declaration", })
      vim.keymap.set("n", leader .. "dT", vim.lsp.buf.declaration, { buffer = bufnr, desc = "vim.lsp.buf.declaration", })
    end

    vim.keymap.set("n", leader .. "n",  telescope.lsp_references,  { buffer = bufnr, desc = "telescope.lsp_references", })
    vim.keymap.set("n", leader .. "N",  vim.lsp.buf.references,    { buffer = bufnr, desc = "vim.lsp.buf.references", })

    vim.keymap.set("n", leader .. "d-", vim.cmd.LspRestart,        { buffer = bufnr, desc = ":LspRestart", })
    vim.keymap.set("n", leader .. "da", vim.lsp.buf.code_action,   { buffer = bufnr, desc = "vim.lsp.buf.code_action", })
    vim.keymap.set("n", leader .. "de", dev.lsp_rename,            { buffer = bufnr, desc = "vim.lsp.buf.rename", })
    vim.keymap.set("n", leader .. "df", vim.diagnostic.open_float, { buffer = bufnr, desc = "vim.diagnostic.open_float", })
    vim.keymap.set("n", leader .. "dh", vim.lsp.buf.hover,         { buffer = bufnr, desc = "vim.lsp.buf.hover", })
    vim.keymap.set("n", leader .. "dl", telescope.diagnostics,     { buffer = bufnr, desc = "telescope.diagnostics", })
    vim.keymap.set("n", leader .. "dq", vim.diagnostic.setqflist,  { buffer = bufnr, desc = "vim.diagnostic.setqflist", })
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
  cmd = { "ccls" },
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
  cmd = { "vscode-json-language-server", "--stdio" },
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
  cmd = { "lua-language-server" },
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
  cmd = { "yaml-language-server", "--stdio" },
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
  cmd = { "zls" },
}
lspconfig.zls.setup(zls)

function M.goto_prev()
  if vim.fn.has("nvim-0.11") == 1 then
    vim.diagnostic.jump({ count = -1, float = true, wrap = false, })
  else
    vim.diagnostic.goto_prev({ wrap = false }) ---@diagnostic disable-line: deprecated
  end
end

function M.goto_next()
  if vim.fn.has("nvim-0.11") == 1 then
    vim.diagnostic.jump({ count = 1, float = true, wrap = false, })
  else
    vim.diagnostic.goto_next({ wrap = false }) ---@diagnostic disable-line: deprecated
  end
end

-- init

return M
