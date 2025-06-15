local M = {
  -- set by dirs.lua
  init_cwd = vim.loop.cwd(),
  startup_dir = nil,
}

function M.update_path()
  vim.o.path = vim.loop.cwd() .. "/**"
end

function M.update_title()
  local cwd = vim.loop.cwd()

  -- this should never be visible
  if not vim.env.TERM_TITLE then
    return
  end

  -- avoid spawning a shell
  if vim.env.NO_GIT_PS1 and cwd then
    for d in vim.env.NO_GIT_PS1:gmatch("([^|]+)|?") do
      if cwd:find(d, 0, true) then
        vim.o.titlestring = cwd
        return
      end
    end
  end

  -- execute async as this is slow
  vim.system({ "zsh", "-c", "printtermtitle", }, { text = true }, function(out)
    -- wait for main thread to write
    vim.schedule(function()
      vim.o.titlestring = out.stdout
    end)
  end)
end

-- return to initial cwd
function M.cd()
  vim.cmd.cd(M.init_cwd)
end

return M
