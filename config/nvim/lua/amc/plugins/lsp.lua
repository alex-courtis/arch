local M = {}

local require = require("amc.require").or_empty

local K = require("amc.util").K

local telescope = require("amc.plugins.telescope")
local snippet = require("vim.snippet")

--
-- Map
--

---@type elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>>
local function on_attach(client, bufnr)

  -- see :help lsp-defaults
  pcall(vim.keymap.del, "n", "K", { buffer = bufnr })

  -- no need to rebind c-]
  -- vim.lsp.tagfunc() indicates that it calls textDocument/definition,
  -- however vim.lsp.buf.definition returns two results e.g. wk.Spec
  if client.server_capabilities.definitionProvider then
    -- K.n_lb("t",  vim.lsp.buf.definition, bufnr, "LSP: Definition", })
    K.n_lb("dt", vim.lsp.buf.definition, bufnr, "LSP: Definition")
  end

  if client.server_capabilities.declarationProvider then
    K.n_lb("T",  vim.lsp.buf.declaration, bufnr, "LSP: Declaration")
    K.n_lb("dT", vim.lsp.buf.declaration, bufnr, "LSP: Declaration")
  end

  K.n_lb("n",  telescope.lsp_references,        bufnr, "Telescope: References")
  K.n_lb("N",  vim.lsp.buf.references,          bufnr, "LSP: References")

  K.n_lb("d-", vim.cmd.LspRestart,              bufnr, "LSP: Restart")
  K.n_lb("d_", M.disable,                       bufnr, "LSP: Disable Active Clients")
  K.n_lb("da", vim.lsp.buf.code_action,         bufnr, "LSP: Code Action")
  K.n_lb("de", vim.lsp.buf.rename,              bufnr, "LSP: Rename")
  K.n_lb("df", vim.diagnostic.open_float,       bufnr, "Diagnostics: Float")
  K.n_lb("dh", vim.lsp.buf.hover,               bufnr, "LSP: Hover")
  K.n_lb("dl", telescope.diagnostics_workspace, bufnr, "Telescope: Diagnostics Workspace")
  K.n_lb("dL", telescope.diagnostics,           bufnr, "Telescope: Diagnostics")
  K.n_lb("dq", vim.diagnostic.setqflist,        bufnr, "Diagnostics: QuickFix")

  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, bufnr, {})
  end

  -- client:supports_method  Always returns true for unknown off-spec methods
  if client.name == "ccls" then
    K.n_lb("ds", vim.cmd.LspCclsSwitchSourceHeader, bufnr, "ccls: Switch Source Header")
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
}

---Global and local on_attach will clobber each other so wrap them
---@param name string
---@return elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>>
local function build_on_attach(name)

  ---@type elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>>
  local config_on_attach = vim.lsp.config[name].on_attach

  return function(client, bufnr)
    if config_on_attach then
      config_on_attach(client, bufnr)
    end
    on_attach(client, bufnr)
  end
end

--
-- Extend nvim-lspconfig from nvim-lspconfig/lsp/yamlls.lua, not lspconfig/configs/yamlls.lua
--

--
-- ccls
--

---@type vim.lsp.Config
vim.lsp.config.ccls = {
  on_attach = build_on_attach("ccls"),
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
vim.lsp.enable("ccls")

--
-- json
--
---@type vim.lsp.Config
vim.lsp.config.jsonls = {
  on_attach = build_on_attach("jsonls"),
  filetypes = { "json", "jsonc", "json5" },
}
vim.lsp.enable("jsonls")

--
-- lua
--
---@type vim.lsp.Config
vim.lsp.config.lua_ls = {
  on_attach = build_on_attach("lua_ls"),
  settings = {
    Lua = {
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
vim.lsp.config.yamlls = {
  on_attach = build_on_attach("yamlls"),
}
vim.lsp.enable("yamlls")

--
-- Functions
--

-- nvim-lspconfig stop is in flux at 11.2:
-- old and new versions have different problems, work around for now
function M.disable()
  vim.cmd.LspStop()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    print("disabling " .. client.name)
    vim.lsp.enable(client.name, false)
  end
end

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
