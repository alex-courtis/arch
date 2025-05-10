local M = {}

local require = require("amc.require").or_empty

local K = require("amc.util").K

local telescope = require("amc.plugins.telescope")
local snippet = require("vim.snippet")

--
-- Map
--

--- @param buffer number
--- @param client vim.lsp.Client
local function on_attach(client, buffer)

  -- see :help lsp-defaults
  pcall(vim.keymap.del, "n", "K", { buffer = buffer })

  -- no need to rebind c-]
  -- vim.lsp.tagfunc() indicates that it calls textDocument/definition,
  -- however vim.lsp.buf.definition returns two results e.g. wk.Spec
  if client.server_capabilities.definitionProvider then
    -- K.n_lb("t",  vim.lsp.buf.definition, bufnr, "vim.lsp.buf.definition", })
    K.n_lb("dt", vim.lsp.buf.definition, buffer, "vim.lsp.buf.definition")
  end

  if client.server_capabilities.declarationProvider then
    K.n_lb("T",  vim.lsp.buf.declaration, buffer, "vim.lsp.buf.declaration")
    K.n_lb("dT", vim.lsp.buf.declaration, buffer, "vim.lsp.buf.declaration")
  end

  K.n_lb("n",  telescope.lsp_references,  buffer, "telescope.lsp_references")
  K.n_lb("N",  vim.lsp.buf.references,    buffer, "vim.lsp.buf.references")

  K.n_lb("d-", vim.cmd.LspRestart,        buffer, ":LspRestart")
  K.n_lb("da", vim.lsp.buf.code_action,   buffer, "vim.lsp.buf.code_action")
  K.n_lb("de", vim.lsp.buf.rename,        buffer, "vim.lsp.buf.rename")
  K.n_lb("df", vim.diagnostic.open_float, buffer, "vim.diagnostic.open_float")
  K.n_lb("dh", vim.lsp.buf.hover,         buffer, "vim.lsp.buf.hover")
  -- TODO restrict to the current buffer's namespace
  K.n_lb("dl", telescope.diagnostics,     buffer, "telescope.diagnostics")
  K.n_lb("dq", vim.diagnostic.setqflist,  buffer, "vim.diagnostic.setqflist")

  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, buffer, {})
  end
end

--
-- Global diagnostics config
--
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
}, nil)

--
-- Base LSP config
--
---@type vim.lsp.Config
vim.lsp.config["*"] = {
  on_attach = on_attach,
}

--
-- Extend nvim-lspconfig from nvim-lspconfig/lsp/yamlls.lua, not lspconfig/configs/yamlls.lua
--

--
-- ccls
--

-- config and local on_attach will override each other, hence we retain it
---@type elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>
local ccls_config_on_attach = vim.lsp.config.ccls.on_attach

---@type vim.lsp.Config
vim.lsp.config.ccls = {
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

  on_attach = function(client, buffer)
    ccls_config_on_attach(client, buffer)
    on_attach(client, buffer)
    K.n_lb("ds", vim.cmd.LspCclsSwitchSourceHeader, buffer, ":LspCclsSwitchSourceHeader")
  end,
}
vim.lsp.enable("ccls")

--
-- json
--
---@type vim.lsp.Config
vim.lsp.config.jsonls = {
  filetypes = { "json", "jsonc", "json5" },
}
vim.lsp.enable("jsonls")

--
-- lua
--
---@type vim.lsp.Config
vim.lsp.config.lua_ls = {
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
    }
  },
}
vim.lsp.enable("lua_ls")

--
-- yaml
--
---@type vim.lsp.Config
vim.lsp.config.yamlls = {}
vim.lsp.enable("yamlls")

--
-- Functions
--

function M.prev_diagnostic()
  if vim.fn.has("nvim-0.11") == 1 then
    vim.diagnostic.jump({ count = -1, float = true, wrap = false, })
  else
    vim.diagnostic.goto_prev({ wrap = false }) ---@diagnostic disable-line: deprecated
  end
end

function M.next_diagnostic()
  if vim.fn.has("nvim-0.11") == 1 then
    vim.diagnostic.jump({ count = 1, float = true, wrap = false, })
  else
    vim.diagnostic.goto_next({ wrap = false }) ---@diagnostic disable-line: deprecated
  end
end

--- @param direction (vim.snippet.Direction) Navigation direction. -1 for previous, 1 for next.
local function snippet_jump(direction)
  if not snippet or not snippet._session then
    return
  end

  local cur_tabstop = snippet._session.current_tabstop.index
  local num_tabstops = table.maxn(snippet._session.tabstops)

  -- don't jump beyond the last of the tabstops, instead wrap forwards
  if direction == 1 and cur_tabstop >= num_tabstops then
    vim.snippet.jump(1 - num_tabstops)
    return
  end

  -- wrap backwards
  if direction == -1 and cur_tabstop <= 1 then
    vim.snippet.jump(num_tabstops - 1)
    return
  end

  -- regular jump
  vim.snippet.jump(direction)
end

function M.next_snippet()
  snippet_jump(1)
end

function M.prev_snippet()
  snippet_jump(-1)
end

return M
