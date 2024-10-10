local INSTALL_PATH = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local COMPILE_PATH = vim.fn.stdpath("data") .. "/site/pack/packer/compiled/plugin/packer_compiled.lua"

local function bootstrap()
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", INSTALL_PATH })
  vim.cmd.packadd("packer.nvim")
end

---@param plugins table
---@return boolean packer was installed
return function(plugins)
  local present, packer = pcall(require, "packer")

  if not present then
    bootstrap()
    packer = require("packer")
  end

  packer.init({ compile_path = COMPILE_PATH })

  packer.reset()

  packer.use("wbthomason/packer.nvim")
  packer.use(plugins)

  if not present then
    require("packer").sync()
  end

  return not present
end
