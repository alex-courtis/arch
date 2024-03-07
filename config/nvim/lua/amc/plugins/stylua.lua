local stylua_ok, stylua = pcall(require, "stylua-nvim")

if not stylua_ok then
  return
end

local config = {
  error_display_strategy = "loclist",
}

-- init
stylua.setup(config)
