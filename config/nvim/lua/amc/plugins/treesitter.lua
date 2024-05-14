local configs_ok, configs = pcall(require, "nvim-treesitter.configs")

if not configs_ok then
  return
end

configs.setup({
  modules = {},
  sync_install = false,
  ensure_installed = {},

  -- alternative to highlight.disable;  :TSInstall vimdoc  :TSUninstall vimdoc
  ignore_install = {}, -- { "vimdoc", "markdown" },

  -- eventually turn this off and add to ignore_install or highlight.disable
  auto_install = true,

  highlight = {
    enable = true,

    -- alternative to not installing
    disable = { "vimdoc", "markdown" },
  },
})
