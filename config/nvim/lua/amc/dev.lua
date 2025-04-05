local BUILD_TYPE = require("amc.enum").BUILD_TYPE

local buffers = require("amc.buffers")

local M = {}

---@type string
local make_test_target = "test"

local FILES_TO_TYPES = {
  Makefile = BUILD_TYPE.make,
  GNUmakefile = BUILD_TYPE.make,
  ["build.zig"] = BUILD_TYPE.make,

  ["meson.build"] = BUILD_TYPE.meson,
}

---scan for files that indicate build type
---@return BUILD_TYPE?
local function build_type()
  for f, t in pairs(FILES_TO_TYPES) do
    if vim.loop.fs_stat(f) then
      return t
    end
  end
  return nil
end

local function meson(args)
  local prev_makeprg = vim.o.makeprg
  vim.o.makeprg = "meson"
  vim.cmd.make(vim.list_extend({ "setup", "build" }, args or {}))
  vim.o.makeprg = prev_makeprg
end

local function ninja(args)
  if not vim.loop.fs_stat("build") then
    meson({})
  end
  local prev_makeprg = vim.o.makeprg
  vim.o.makeprg = "ninja"
  vim.cmd.make(vim.list_extend({ "-C", "build" }, args or {}))
  vim.o.makeprg = prev_makeprg
end

function M.clean()
  local bt = build_type()

  if bt == BUILD_TYPE.make then
    vim.cmd.make({ args = { "clean" } })
  elseif bt == BUILD_TYPE.meson then
    ninja({ "clean" })
  end
end

function M.install()
  local bt = build_type()

  if bt == BUILD_TYPE.make then
    vim.cmd.make({ args = { "install" } })
  elseif bt == BUILD_TYPE.meson then
    ninja({ "install" })
  end
end

function M.test()
  local bt = build_type()

  buffers.update()

  if bt == BUILD_TYPE.make then
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    local tst_name = buf_name:match("^.*/tst%-(.*)%.c$")
    if tst_name then
      make_test_target = "test-" .. tst_name
    end
    vim.cmd.make({ args = { make_test_target } })
  elseif bt == BUILD_TYPE.meson then
    ninja({ "test" })
  end
end

function M.test_all()
  local bt = build_type()

  buffers.update()

  if bt == BUILD_TYPE.make then
    make_test_target = "test"
    vim.cmd.make({ args = { make_test_target } })
  elseif bt == BUILD_TYPE.meson then
    M.test()
  end
end

function M.build()
  local bt = build_type()

  buffers.update()

  if bt == BUILD_TYPE.make then
    vim.cmd.make()
  elseif bt == BUILD_TYPE.meson then
    ninja({})
  end
end

function M.source()
  local filetype = vim.bo.filetype
  if filetype == "lua" or filetype == "vim" then
    vim.cmd.source()
  end
end

function M.lsp_rename()
  buffers.update()
  vim.lsp.buf.rename()
  buffers.update()
end

function M.format()
  if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
    vim.cmd([[silent! norm! gg=G``]])
    return
  end

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format()
      buffers.update()
      return
    end
  end

  vim.cmd([[silent! norm! gg=G``]])
end

function M.ft_lua(data)
  -- let emmylua apply [*.lua] without globals, for when filename is not *.lua
  vim.b[data.buf].editorconfig = false

  -- man is not useful, vim help usually is
  vim.api.nvim_set_option_value("keywordprg", ":help", { buf = data.buf })
end

function M.ft_c(data)
  -- line comments please
  vim.api.nvim_set_option_value("commentstring", "// %s", { buf = data.buf })
end

return M
