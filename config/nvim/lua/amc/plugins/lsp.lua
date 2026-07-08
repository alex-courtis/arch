local locations = require("amc.locations")

local M = {}

local require = require("amc.require").or_empty

local K = require("amc.util").K

local telescope = require("amc.plugins.telescope")
local snippet = require("vim.snippet")
local nvim_tree_api = require("nvim-tree.api")
local dev = require("amc.dev")

--
-- Map
--

-- see /usr/share/nvim/runtime/lua/vim/lsp/protocol.lua for method names

---@type elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>
local function on_attach(client, bufnr)

  -- see :help lsp-defaults
  pcall(vim.keymap.del, "n", "K", { buffer = bufnr })

  -- c-] is automatically bound to vim.lsp.tagfunc() which
  -- calls textDocument/definition, then workspace/symbol, then tags
  -- It does something completely different to vim.lsp.buf.definition
  -- Avoid it:
  --  It blocks for 1s then fails back
  --  On no results it prints two error lines
  -- E433: No tags file
  -- E426: Tag not found: xxx

  if client.server_capabilities.documentSymbolProvider then
    K.n_lb("dd", telescope.lsp_functions,  bufnr, "Telescope: buffer functions")
    K.n_lb("dv", telescope.lsp_variables,  bufnr, "Telescope: buffer variables")

    K.n_lb("u",  locations.jump_prev_func, bufnr, "LSP: previous function")
    K.n_lb("e",  locations.jump_next_func, bufnr, "LSP: next function")
  end

  if client.server_capabilities.workspaceSymbolProvider then
    K.ns__(",n", telescope.lsp_dynamic_functions, "Telescope: dynamic workspace functions")
  end

  if client.server_capabilities.definitionProvider then
    K.n__b("t", locations.definition, bufnr, "LSP: Definition")
  end

  if client.server_capabilities.declarationProvider then
    K.n__b("T", locations.declaration, bufnr, "LSP: Declaration")
  end

  if client.server_capabilities.typeDefinitionProvider then
    K.n_lb("dt", locations.type_definition, bufnr, "LSP: Type Definition")
  end

  if client.server_capabilities.implementationProvider then
    K.n__b("dm", locations.implementation, bufnr, "LSP: Implementation")
  end

  if client.server_capabilities.referencesProvider then
    K.n_lb("n", telescope.lsp_references, bufnr, "Telescope: References")
    K.n_lb("N", vim.lsp.buf.references,   bufnr, "LSP: References")
  end

  if client.server_capabilities.callHierarchyProvider then
    K.n_lb("do", vim.lsp.buf.outgoing_calls, bufnr, "LSP: Outgoing Calls")
    K.n_lb("di", vim.lsp.buf.incoming_calls, bufnr, "LSP: Incoming Calls")
  end

  K.n_l_("d-", function() M.restart(client) end, "LSP: Restart")
  K.n_l_("d_", function() M.toggle(client) end,  "LSP: Toggle")

  if client.server_capabilities.codeActionProvider then
    K.n_lb("da", vim.lsp.buf.code_action, bufnr, "LSP: Code Action")
  end

  K.n_lb("df", vim.diagnostic.open_float, bufnr, "Diagnostics: Float")

  if client.server_capabilities.hoverProvider then
    K.n_lb("dh", vim.lsp.buf.hover, bufnr, "LSP: Hover")
  end

  if client.server_capabilities.renameProvider then
    K.n_lb("dr", dev.lsp_rename, bufnr, "LSP: Rename")
  end

  if client.server_capabilities.completionProvider then
    vim.lsp.completion.enable(true, client.id, bufnr, {})
  end
end

--
-- Global diagnostics config
--

---@type table<vim.diagnostic.Severity,string>
local signs_text = nil
if nvim_tree_api then
  local i = nvim_tree_api.config.default().diagnostics.icons
  signs_text = {
    HINT = i and i.hint,
    INFO = i and i.info,
    WARN = i and i.warning,
    ERROR = i and i.error,
  }
end

vim.diagnostic.config({
  signs = {
    text = signs_text,
    priority = 20,
  },
  virtual_text = true,
  severity_sort = true,
}, nil)

--
-- Less logging
--
vim.lsp.log.set_level("ERROR")

--
-- Base LSP config
--
---@type vim.lsp.Config
vim.lsp.config["*"] = {
  flags = {
    debounce_text_changes = 50,
  },
}

---Global and local on_attach will clobber each other so wrap them
---@param name string
---@param client_on_attach elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>?
---@return elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>
local function build_on_attach(name, client_on_attach)

  ---@type elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)>
  local config_on_attach = vim.lsp.config[name].on_attach

  return function(client, bufnr)
    if type(config_on_attach) == "function" then
      config_on_attach(client, bufnr)
    end
    on_attach(client, bufnr)
    if type(client_on_attach) == "function" then
      client_on_attach(client, bufnr)
    end
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
  on_attach = build_on_attach("ccls", function(_, bufnr)
    K.n_lb("ds", vim.cmd.LspCclsSwitchSourceHeader, bufnr, "ccls: Switch Source Header")
    K.n__b(",n", telescope.ccls_dynamic_functions,  bufnr, "ccls: dynamic workspace functions")
  end),

  root_markers = { "compile_commands.json", ".ccls", ".git", "/usr/include/", "/usr/local/include/" },
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

  -- disable all diagnostics and other libraries when in a plugin
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if not path:match(vim.fn.stdpath("data") .. "/site/pack.*") then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua --[[@as vim.lsp.ClientConfig]], {
      diagnostics = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
}
vim.lsp.enable("lua_ls")

--
-- openscad
--
---@type vim.lsp.Config
vim.lsp.config.openscad_lsp = {
  on_attach = build_on_attach("openscad_lsp", function(_, bufnr)
    vim.api.nvim_set_option_value("commentstring", "// %s", { buf = bufnr })
  end),
}
vim.lsp.enable("openscad_lsp")

--
-- yaml
--
---@type vim.lsp.Config
vim.lsp.config.yamlls = {
  on_attach = build_on_attach("yamlls"),
}
vim.lsp.enable("yamlls")

--
-- python
--
---@type vim.lsp.Config
vim.lsp.config.pyright = {
  on_attach = build_on_attach("pyright"),
}
vim.lsp.enable("pyright")

--
-- Functions
--

---@param client vim.lsp.Client
function M.restart(client)
  client:stop(true)
  vim.lsp.enable(client.config)
end

---@param client vim.lsp.Client
function M.toggle(client)
  if (client:is_stopped()) then
    vim.lsp.enable(client.config)
  else
    client:stop(true)
  end
end

function M.prev_diagnostic()
  vim.diagnostic.jump({ count = -1, float = true, wrap = false, })
end

function M.next_diagnostic()
  vim.diagnostic.jump({ count = 1, float = true, wrap = false, })
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
