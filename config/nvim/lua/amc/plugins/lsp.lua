local M = {}

local require = require("amc.require").or_empty

local telescope = require("amc.plugins.telescope")

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
    vim.keymap.set("n", leader .. "de", vim.lsp.buf.rename,        { buffer = bufnr, desc = "vim.lsp.buf.rename", })
    vim.keymap.set("n", leader .. "df", vim.diagnostic.open_float, { buffer = bufnr, desc = "vim.diagnostic.open_float", })
    vim.keymap.set("n", leader .. "dh", vim.lsp.buf.hover,         { buffer = bufnr, desc = "vim.lsp.buf.hover", })
    vim.keymap.set("n", leader .. "dl", telescope.diagnostics,     { buffer = bufnr, desc = "telescope.diagnostics", })
    vim.keymap.set("n", leader .. "dq", vim.diagnostic.setqflist,  { buffer = bufnr, desc = "vim.diagnostic.setqflist", })
  end
end

---
--- Global diagnostics config
---
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
}, nil)

---
--- base LSP config
---
---@type vim.lsp.Config
vim.lsp.config["*"] = {

  on_attach = on_attach,

  root_markers = { ".git" },

  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
  },
}

--
-- ccls
--
---@type vim.lsp.Config
vim.lsp.config.ccls = {

  filetypes = { "c", "cpp", },

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

  -- TODO textDocument/switchSourceHeader
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/ccls.lua
}
vim.lsp.enable("ccls")

--
-- json
--
---@type vim.lsp.Config
vim.lsp.config.jsonls = {

  filetypes = { "json", "jsonc", "json5" },

  cmd = { "vscode-json-language-server", "--stdio" },

}
vim.lsp.enable("jsonls")

--
-- lua
--
---@type vim.lsp.Config
vim.lsp.config.luals = {

  filetypes = { "lua" },

  cmd = { "lua-language-server" },

  root_markers = vim.list_extend({
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
  }, vim.lsp.config["*"].root_markers),

  settings = {
    Lua = {
      workspace = {
        library = {
          "$VIMRUNTIME/lua/vim",
          "${3rd}/luv/library",
        },
      },
      semantic = {
        -- ugly and takes time to set
        variable = false,
      },
    }
  },
}
vim.lsp.enable("luals")

--
-- yaml
--
---@type vim.lsp.Config
vim.lsp.config.yamlls = {

  filetypes = { "yaml" },

  cmd = { "yaml-language-server", "--stdio" },
}
vim.lsp.enable("yamlls")

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

return M
