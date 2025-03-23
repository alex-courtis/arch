local require = require("amc.require_or_nil")

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
  local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

  local function desc(d)
    return vim.tbl_extend("keep", opts, { desc = d })
  end

  for _, leader in ipairs({ "<space>", "<bs>" }) do
    vim.keymap.set("n", leader .. "he", gitsigns.select_hunk,               desc("Select Hunk"))
    vim.keymap.set("v", leader .. "he", gitsigns.select_hunk,               desc("Select Hunk"))
    vim.keymap.set("n", leader .. "j",  next_hunk,                          desc("Next Hunk"))

    vim.keymap.set("n", leader .. "hp", gitsigns.preview_hunk_inline,       desc("Preview Hunk Inline"))
    vim.keymap.set("n", leader .. "k",  prev_hunk,                          desc("Previous Hunk"))

    vim.keymap.set("n", leader .. "hx", gitsigns.reset_hunk,                desc("Reset Hunk"))
    vim.keymap.set("v", leader .. "hx", gitsigns.reset_hunk,                desc("Reset Hunk"))
    vim.keymap.set("n", leader .. "hX", gitsigns.reset_buffer,              desc("Reset Buffer"))

    vim.keymap.set("n", leader .. "hd", gitsigns.diffthis,                  desc("Diff This"))
    vim.keymap.set("n", leader .. "hB", gitsigns.blame_line,                desc("Blame Line"))

    vim.keymap.set("n", leader .. "hl", gitsigns.toggle_current_line_blame, desc("Toggle Current Blame Line"))
    vim.keymap.set("n", leader .. "hs", gitsigns.stage_hunk,                desc("Stage Hunk"))
    vim.keymap.set("v", leader .. "hs", gitsigns.stage_hunk,                desc("Stage Hunk"))
    vim.keymap.set("n", leader .. "hS", gitsigns.stage_buffer,              desc("Stage Buffer"))
  end
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
