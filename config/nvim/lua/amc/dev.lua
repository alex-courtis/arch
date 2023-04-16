local util = require("amc.util")
local stylua = util.require_or_nil("stylua-nvim")

local M = {}

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

function M.format()
  local filetype = vim.bo.filetype

  if stylua and filetype == "lua" then
    stylua.format_file()
  else
    vim.cmd([[norm! gg=G``]])
  end
end

local function meson(args)
  vim.cmd({ cmd = "!", args = vim.list_extend({ "meson", "setup", "build" }, args or {}) })
end

local function ninja(args)
  if not vim.loop.fs_stat("build") then
    meson({})
  end
  vim.cmd({ cmd = "!", args = vim.list_extend({ "ninja", "-C", "build" }, args or {}) })
end

function M.setup()
  local bt = build_type()

  if bt == M.build_type.MESON then
    if vim.loop.fs_stat("build") then
      meson({ "--reconfigure" })
    else
      meson({})
    end
  end
end

function M.clean()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make({ args = { "clean" } })
  elseif bt == M.build_type.MESON then
    ninja({ "clean" })
  end
end

function M.dev()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make({ args = { "dev" } })
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

--- au FileType
function M.FileType(data)
  -- man is not useful, vim help usually is
  if data.match == "lua" then
    vim.api.nvim_buf_set_option(data.buf, "keywordprg", ":help")
  end

  -- line comments please
  if data.match == "c" or data.match == "cpp" then
    vim.api.nvim_buf_set_option(data.buf, "commentstring", "// %s")
  end

  -- no way to remap fugitive and tpope will not add
  if data.match == "fugitive" then
    vim.keymap.set("n", "t", "=", { buffer = data.buf, remap = true })
    vim.keymap.set("n", "x", "X", { buffer = data.buf, remap = true })
  end

  -- keep these roughly in sync with editorconfig, which will not be executed outside of ~
  if vim.tbl_contains({ "lua", "json", "yml", "yaml", "ts", "tf" }, data.match) then
    vim.bo[data.buf].expandtab = true
    vim.bo[data.buf].shiftwidth = 2
    vim.bo[data.buf].softtabstop = 2
    vim.bo[data.buf].tabstop = 2
  end
end

return M
