local M = {}

local stylua_ok, stylua = pcall(require, "stylua-nvim")

--- @enum dev.build_type
M.build_type = {
  MAKE = 0,
  MESON = 1,
}

local FILES_TO_TYPES = {
  Makefile = M.build_type.MAKE,
  GNUmakefile = M.build_type.MAKE,
  ["build.zig"] = M.build_type.MAKE,

  ["meson.build"] = M.build_type.MESON,
}

--- scan for files that indicate build type
--- @return dev.build_type|nil
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

  if bt == M.build_type.MAKE then
    vim.cmd.make({ args = { "clean" } })
  elseif bt == M.build_type.MESON then
    ninja({ "clean" })
  end
end

function M.install()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make({ args = { "install" } })
  elseif bt == M.build_type.MESON then
    ninja({ "install" })
  end
end

function M.test()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make({ args = { "test" } })
  elseif bt == M.build_type.MESON then
    ninja({ "test" })
  end
end

function M.build()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make()
  elseif bt == M.build_type.MESON then
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
  vim.cmd.wall()
  vim.lsp.buf.rename()
  vim.cmd.wall()
end

function M.format()
  if stylua_ok and vim.bo.filetype == "lua" then
    stylua.format_file()
    return
  end

  if vim.fn.has("nvim-0.10") == 1 then
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format()
        return
      end
    end
  elseif vim.lsp.buf.server_ready() then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.server_capabilities.documentFormattingProvided then
        vim.lsp.buf.format()
        return
      end
    end
  end

  vim.cmd([[silent! norm! gg=G``]])
end

return M
