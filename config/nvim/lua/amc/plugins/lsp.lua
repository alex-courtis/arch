local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

local M = {}

local start_client_flags = {
  debounce_text_changes = 500,
}

local config_ccls = {
  flags = start_client_flags,
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
}

local config_lua = {
  flags = start_client_flags,
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          "vim",
        },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
    },
  },
}

local config_zls = {
  flags = start_client_flags,
}

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

function M.goto_prev()
  vim.diagnostic.goto_prev({ wrap = false })
end

function M.goto_next()
  vim.diagnostic.goto_next({ wrap = false })
end

function M.init()
  lspconfig.ccls.setup(config_ccls)
  lspconfig.lua_ls.setup(config_lua)
  lspconfig.zls.setup(config_zls)
end

return M
