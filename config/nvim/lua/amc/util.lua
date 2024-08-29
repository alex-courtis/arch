local M = {}

--- au BufEnter
--- @param data table
function M.reset_mappings(data)
  --- vim maps K to vim.lsp.buf.hover() in Normal mode
  --- https://github.com/neovim/nvim-lspconfig/blob/b972e7154bc94ab4ecdbb38c8edbccac36f83996/README.md#configuration
  pcall(vim.keymap.del, "n", "K", { buffer = data.buf })
end

---Read .nvt-dir and return first path containing /lua/nvim-tree.lua
---@return string dir from file otherwise "nvim-tree/nvim-tree.lua"
function M.nvt_plugin_dir()
  local config_file_path = vim.env.HOME .. "/.nvt-dir"
  if vim.loop.fs_stat(config_file_path) then
    for nvt_dir in io.lines(config_file_path) do
      if vim.loop.fs_stat(nvt_dir .. "/lua/nvim-tree.lua") then
        return nvt_dir
      end
    end
  end
  return "nvim-tree/nvim-tree.lua"
end

return M
