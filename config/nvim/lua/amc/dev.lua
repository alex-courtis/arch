local stylua = require("stylua-nvim")

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

function M.reconfigure()
  local bt = build_type()

  if bt == M.build_type.MESON then
    vim.cmd({ cmd = "!", args = { "meson", "setup", "--reconfigure", "build" } })
  end
end

function M.clean()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make({ args = { "clean" } })
  elseif bt == M.build_type.MESON then
    vim.cmd({ cmd = "!", args = { "ninja", "-C", "build", "clean" } })
  end
end

function M.test()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make({ args = { "test" } })
  elseif bt == M.build_type.MESON then
    vim.cmd({ cmd = "!", args = { "ninja", "-C", "build", "test" } })
  end
end

function M.build()
  local bt = build_type()

  if bt == M.build_type.MAKE then
    vim.cmd.make()
  elseif bt == M.build_type.MESON then
    vim.cmd({ cmd = "!", args = { "ninja", "-C", "build" } })
  end
end

function M.source()
  local filetype = vim.bo.filetype
  if filetype == "lua" or filetype == "vim" then
    vim.cmd.so()
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
end

return M
