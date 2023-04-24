local util = require("amc.util")
local lspconfig = util.require_or_nil("lspconfig")
local cmp_nvim_lsp = util.require_or_nil("cmp_nvim_lsp")

local M = {}

local start_client_flags = {
  debounce_text_changes = 500,
}

local config_ccls = {
  flags = start_client_flags,
  capabilities = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or nil,
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
}

local config_lua = {
  flags = start_client_flags,
  settings = {
    Lua = {
      globals = {
        "vim",
      },
      diagnostics = {
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
      workspace = {
        library = {
          -- 2023 04 24 incomplete
          -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          -- [vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
          -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
      semantic = {
        -- ugly and takes time to set
        variable = false,
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
  if not lspconfig then
    return
  end

  lspconfig.ccls.setup(config_ccls)
  lspconfig.lua_ls.setup(config_lua)
  lspconfig.zls.setup(config_zls)
end

return M
