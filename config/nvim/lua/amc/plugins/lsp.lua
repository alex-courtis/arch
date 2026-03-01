local M = {}

local require = require("amc.require").or_empty

local K = require("amc.util").K

local telescope = require("amc.plugins.telescope")
local snippet = require("vim.snippet")

--
-- Location Jumping
--

---vim/lsp/buf.lua get_locations hacked to
---- filter origin, lua builtins and same line targets
---- always jump to first target
---@param method string
---@param opts? vim.lsp.LocationOpts
local function get_locations(method, opts)

  local api = vim.api
  local lsp = vim.lsp
  local util = vim.lsp.util

  ---@type lsp.TextDocumentPositionParams
  local params

  opts = opts or {}
  local bufnr = api.nvim_get_current_buf()
  local win = api.nvim_get_current_win()

  local clients = lsp.get_clients({ method = method, bufnr = bufnr })
  if not next(clients) then
    vim.notify(lsp._unsupported_method(method), vim.log.levels.WARN)
    return
  end

  local from = vim.fn.getpos(".")
  from[1] = bufnr
  local tagname = vim.fn.expand("<cword>")

  lsp.buf_request_all(bufnr, method, function(client)
    params = util.make_position_params(win, client.offset_encoding)
    return params
  end, function(results)
    ---@type vim.quickfix.entry[]
    local all_items = {}

    for client_id, res in pairs(results) do
      local client = assert(lsp.get_client_by_id(client_id))
      local locations = {}
      if res then
        locations = vim.islist(res.result) and res.result or { res.result }
      end
      local items = util.locations_to_items(locations, client.offset_encoding)
      vim.list_extend(all_items, items)
    end

    local filtered_origin = 0
    local filtered_builtin = 0
    local filtered_same_line = 0
    local file_lines = {}

    all_items = vim.tbl_filter(function(item)
      if not item.user_data then
        return true
      end

      -- maybe range
      local range = item.user_data.targetRange or item.user_data.range
      if not range then
        return true
      end

      -- maybe uri
      local uri = item.user_data.targetUri or item.user_data.uri
      if not uri then
        return true
      end

      -- LUA builtins
      if uri:match("builtin.lua$") then
        filtered_builtin = filtered_builtin + 1
        return false
      end

      -- references to origin line
      if uri == params.textDocument.uri and
        range.start.line == params.position.line then
        filtered_origin = filtered_origin + 1
        return false
      end

      -- multiple references to the same line
      local file_line = uri .. range.start.line
      if file_lines[file_line] then
        filtered_same_line = filtered_same_line + 1
        return false
      end
      file_lines[file_line] = true

      return true
    end, all_items)

    if filtered_origin + filtered_builtin + filtered_same_line > 0 or #all_items == 0 then
      vim.notify(string.format(
          "%s  '%s'  %sfiltered %d origin, %d builtin, %d same line",
          method,
          tagname,
          #all_items == 0 and "not found, " or "",
          filtered_origin,
          filtered_builtin,
          filtered_same_line
        ),
        vim.log.levels.INFO)
    end

    if #all_items == 0 then
      return
    end

    local title = "LSP locations"

    if #all_items > 0 then
      local item = all_items[1]
      local b = item.bufnr or vim.fn.bufadd(item.filename)

      -- Save position in jumplist
      vim.cmd("normal! m'")
      -- Push a new item into tagstack
      local tagstack = { { tagname = tagname, from = from } }
      vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")

      vim.bo[b].buflisted = true
      local w = win
      if opts.reuse_win and api.nvim_win_get_buf(w) ~= b then
        w = vim.fn.bufwinid(b)
        w = w >= 0 and w or vim.fn.win_findbuf(b)[1] or win
        if w ~= win then
          api.nvim_set_current_win(w)
        end
      end
      api.nvim_win_set_buf(w, b)
      api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
      vim._with({ win = w }, function()
        -- Open folds under the cursor
        vim.cmd("normal! zv")
      end)
    end

    if #all_items == 1 then
      return
    end

    if opts.loclist then
      vim.fn.setloclist(0, {}, " ", { title = title, items = all_items })
      vim.cmd.lopen()
      vim.cmd("wincmd p")
    else
      vim.fn.setqflist({}, " ", { title = title, items = all_items })
      vim.cmd("botright copen")
      vim.cmd("wincmd p")
    end
  end)

end

--
-- Map
--

-- see /usr/share/nvim/runtime/lua/vim/lsp/protocol.lua for available methods

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

  if client.server_capabilities.definitionProvider then
    K.n__b("t", function(opts) get_locations("textDocument/definition", opts) end, bufnr, "LSP: textDocument/definition")
  end

  if client.server_capabilities.declarationProvider then
    K.n__b("T", function(opts) get_locations("textDocument/declaration", opts) end, bufnr, "LSP: textDocument/declaration")
  end

  if client.server_capabilities.typeDefinitionProvider then
    K.n_lb("dt", function(opts) get_locations("textDocument/typeDefinition", opts) end, bufnr, "LSP: textDocument/typeDefinition")
  end

  if client.server_capabilities.implementationProvider then
    K.n__b("dm", function(opts) get_locations("textDocument/implementation", opts) end, bufnr, "LSP: textDocument/implementation")
  end

  if client.server_capabilities.referencesProvider then
    K.n_lb("n", telescope.lsp_references, bufnr, "Telescope: References")
    K.n_lb("N", vim.lsp.buf.references,   bufnr, "LSP: textDocument/references")
  end

  if client.server_capabilities.callHierarchyProvider then
    K.n_lb("do", vim.lsp.buf.outgoing_calls, bufnr, "LSP: callHierarchy/outgoingCalls")
    K.n_lb("di", vim.lsp.buf.incoming_calls, bufnr, "LSP: callHierarchy/incomingCalls")
  end

  K.n_lb("d-", vim.cmd.LspRestart, bufnr, "LSP: Restart")
  K.n_lb("d_", M.disable,          bufnr, "LSP: Disable Active Clients")

  if client.server_capabilities.codeActionProvider then
    K.n_lb("da", vim.lsp.buf.code_action, bufnr, "LSP: textDocument/codeAction")
  end

  K.n_lb("df", vim.diagnostic.open_float, bufnr, "Diagnostics: Float")

  if client.server_capabilities.hoverProvider then
    K.n_lb("dh", vim.lsp.buf.hover, bufnr, "LSP: textDocument/hover")
  end

  K.n_lb("dl", telescope.diagnostics_workspace, bufnr, "Telescope: Diagnostics Workspace")
  K.n_lb("dL", telescope.diagnostics,           bufnr, "Telescope: Diagnostics")

  if client.server_capabilities.renameProvider then
    K.n_lb("dr", vim.lsp.buf.rename, bufnr, "LSP: textDocument/rename")
  end

  K.n_lb("dq", vim.diagnostic.setqflist, bufnr, "Diagnostics: QuickFix")

  if client.server_capabilities.completionProvider then
    vim.lsp.completion.enable(true, client.id, bufnr, {}) -- textDocument/completion
  end

  -- client:supports_method  Always returns true for unknown off-spec methods
  if client.name == "ccls" then
    K.n_lb("ds", vim.cmd.LspCclsSwitchSourceHeader, bufnr, "LSP: textDocument/switchSourceHeader")
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
-- Less logging
--
vim.lsp.set_log_level("ERROR")

--
-- Base LSP config
--
---@type vim.lsp.Config
vim.lsp.config["*"] = {
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
    if type(client_on_attach) == "function" then
      client_on_attach(client, bufnr)
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
