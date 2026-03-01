local M = {}

--
-- Location Jumping
--

--- @type vim.lsp.LocationOpts
local opts_default = {
  reuse_win = true,
}

---@class amc.LocationsFiltered
---@field private origin integer
---@field private builtin integer
---@field private same_line integer
local LocationsFiltered = {}

---@return amc.LocationsFiltered
function LocationsFiltered:new()

  ---@type amc.LocationsFiltered
  local o = {
    origin = 0,
    builtin = 0,
    same_line = 0,
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function LocationsFiltered:inc_origin()
  self.origin = self.origin + 1
end

function LocationsFiltered:inc_builtin()
  self.builtin = self.builtin + 1
end

function LocationsFiltered:inc_same_line()
  self.same_line = self.same_line + 1
end

---@return string empty when no filtering occurred
function LocationsFiltered:summary()
  local reasons = {}

  if self.origin > 0 then
    table.insert(reasons, self.origin .. " origin")
  end
  if self.builtin > 0 then
    table.insert(reasons, self.builtin .. " builtin")
  end
  if self.same_line > 0 then
    table.insert(reasons, self.same_line .. " same line")
  end

  if #reasons > 0 then
    return "  filtered: " .. table.concat(reasons, ", ")
  else
    return ""
  end
end

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

    ---@type table<string, boolean>
    local range_lines = {}

    local filtered = LocationsFiltered:new()

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
        filtered:inc_builtin()
        return false
      end

      -- references to origin line
      if uri == params.textDocument.uri and
        range.start.line == params.position.line then
        filtered:inc_origin()
        return false
      end

      -- multiple references to the same line
      local file_line = uri .. range.start.line
      if range_lines[file_line] then
        filtered:inc_same_line()
        return false
      end
      range_lines[file_line] = true

      return true
    end, all_items)

    local filtered_summary = filtered:summary()
    local failure_reason = ""

    if #all_items == 0 then
      if #filtered_summary == 0 then
        failure_reason = "  not found"
      else
        failure_reason = "  skipped"
      end
    end

    vim.notify(string.format(
        "%s  '%s'%s%s",
        method:gsub("textDocument/", "LSP "),
        tagname,
        failure_reason,
        filtered_summary
      ),
      vim.log.levels.INFO
    )

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

    vim.fn.setqflist({}, " ", { title = title, items = all_items })
    vim.cmd("botright copen")
    vim.cmd("wincmd p")
  end)

end

--- Jumps to the declaration of the symbol under the cursor.
--- @note Many servers do not implement this method. Generally, see |vim.lsp.buf.definition()| instead.
--- @param opts? vim.lsp.LocationOpts
function M.declaration(opts)
  get_locations(vim.lsp.protocol.Methods.textDocument_declaration, opts or opts_default)
end

--- Jumps to the definition of the symbol under the cursor.
--- @param opts? vim.lsp.LocationOpts
function M.definition(opts)
  get_locations(vim.lsp.protocol.Methods.textDocument_definition, opts or opts_default)
end

--- Jumps to the definition of the type of the symbol under the cursor.
--- @param opts? vim.lsp.LocationOpts
function M.type_definition(opts)
  get_locations(vim.lsp.protocol.Methods.textDocument_typeDefinition, opts or opts_default)
end

--- Lists all the implementations for the symbol under the cursor in the
--- quickfix window.
--- @param opts? vim.lsp.LocationOpts
function M.implementation(opts)
  get_locations(vim.lsp.protocol.Methods.textDocument_implementation, opts or opts_default)
end

return M
