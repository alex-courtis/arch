local require = require("amc.require").or_nil

local K = require("amc.util").K

local gitsigns = require("gitsigns")

if not gitsigns then
  return
end

local function next_hunk()
  gitsigns.nav_hunk("next")
end

local function prev_hunk()
  gitsigns.nav_hunk("prev")
end

local on_attach = function(bufnr)
  local opts = { nowait = true }

  K.n_lb("he", gitsigns.select_hunk,               bufnr, "Gitsigns: Select Hunk",  opts)
  K.v_lb("he", gitsigns.select_hunk,               bufnr, "Gitsigns: Select Hunk",  opts)
  K.n_lb("j",  next_hunk,                          bufnr, "Gitsigns: Next Hunk",    opts)

  K.n_lb("hp", gitsigns.preview_hunk_inline,       bufnr, "Gitsigns: Preview",      opts)
  K.n_lb("k",  prev_hunk,                          bufnr, "Gitsigns: Prev Hunk",    opts)

  K.n_lb("hx", gitsigns.reset_hunk,                bufnr, "Gitsigns: Reset Hunk",   opts)
  K.v_lb("hx", gitsigns.reset_hunk,                bufnr, "Gitsigns: Reset Hunk",   opts)
  K.n_lb("hX", gitsigns.reset_buffer,              bufnr, "Gitsigns: Reset Buffer", opts)

  K.n_lb("hd", gitsigns.diffthis,                  bufnr, "Gitsigns: Diff This",    opts)
  K.n_lb("hB", gitsigns.blame_line,                bufnr, "Gitsigns: Blame Line",   opts)

  K.n_lb("hs", gitsigns.stage_hunk,                bufnr, "Gitsigns: Stage Hunk",   opts)
  K.v_lb("hs", gitsigns.stage_hunk,                bufnr, "Gitsigns: Stage Hunk",   opts)
  K.n_lb("hS", gitsigns.stage_buffer,              bufnr, "Gitsigns: Stage Buffer", opts)
  K.n_lb("ht", gitsigns.toggle_current_line_blame, bufnr, "Gitsigns: Blame Toggle", opts)
end

local config = {
  numhl = true,
  current_line_blame_opts = {
    delay = 100,
  },
  on_attach = on_attach,
}

-- init
gitsigns.setup(config)
