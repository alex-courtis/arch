local configs_ok, configs = pcall(require, "nvim-treesitter.configs")

if not configs_ok then
  return
end

-- most of these do not look good
-- install explicitly e.g. :TSInstall cpp

-- :TSBufToggle highlight

configs.setup({
  modules = {},

  sync_install = false,

  ensure_installed = {},

  ignore_install = {},

  auto_install = false,

  highlight = {
    enable = true,

    disable = {},
  },
})
