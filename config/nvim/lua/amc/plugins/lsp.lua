local M = {}

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not lspconfig_ok or not cmp_nvim_lsp_ok then
  return M
end

--- @type vim.lsp.Client.Flags
local start_client_flags = {
  debounce_text_changes = 500,
  exit_timeout = false,
}

--
-- cc
--
--- @type lspconfig.Config
local ccls = {
  flags = start_client_flags,
  capabilities = cmp_nvim_lsp.default_capabilities(),
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
--- @type lspconfig.Config
local jsonls = {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}
jsonls.capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.jsonls.setup(jsonls)

--
-- lua
--
--- @type lspconfig.Config
local luals = {
  flags = start_client_flags,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    Lua = {
      runtime = {
        version = "Lua 5.1",
      },
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
--- @type lspconfig.Config
local yamlls = {
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
--- @type lspconfig.Config
local zls = {
  flags = start_client_flags,
  capabilities = cmp_nvim_lsp.default_capabilities(),
}
lspconfig.zls.setup(zls)

function M.goto_definition_or_tag()
  vim.fn.settagstack(vim.fn.win_getid(), { items = {} })

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.server_capabilities.definitionProvider then
      vim.lsp.buf.definition()
      return
    end
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
