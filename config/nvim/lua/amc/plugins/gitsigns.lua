local gitsigns = require("gitsigns")

local M = {}

local on_attach = function(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

  local function desc(d)
    return vim.tbl_extend("keep", opts, { desc = d })
  end

  for _, leader in ipairs({ "<space>", "<bs>" }) do
    -- ;a'

    -- ,oq

    -- .
    vim.keymap.set("n", leader .. "he", gitsigns.select_hunk, desc("Select Hunk"))
    vim.keymap.set("v", leader .. "he", gitsigns.select_hunk, desc("Select Hunk"))
    vim.keymap.set("n", leader .. "j", gitsigns.next_hunk, desc("Next Hunk"))

    vim.keymap.set("n", leader .. "hp", gitsigns.preview_hunk_inline, desc("Preview Hunk Inline"))
    vim.keymap.set("n", leader .. "hu", gitsigns.undo_stage_hunk, desc("Undo Stage Hunk"))
    vim.keymap.set("n", leader .. "k", gitsigns.prev_hunk, desc("Previous Hunk"))

    -- yi
    vim.keymap.set("n", leader .. "hx", gitsigns.reset_hunk, desc("Reset Hunk"))
    vim.keymap.set("v", leader .. "hx", gitsigns.reset_hunk, desc("Reset Hunk"))
    vim.keymap.set("n", leader .. "hX", gitsigns.reset_buffer, desc("Reset Buffer"))

    -- f
    vim.keymap.set("n", leader .. "hd", gitsigns.diffthis, desc("Diff This"))
    vim.keymap.set("n", leader .. "hB", gitsigns.blame_line, desc("Blame Line"))

    -- ghm

    -- c
    vim.keymap.set("n", leader .. "ht", gitsigns.toggle_deleted, desc("Toggle Deleted"))
    -- w

    -- rnv

    vim.keymap.set("n", leader .. "hl", gitsigns.toggle_current_line_blame, desc("Toggle Current Blame Line"))
    vim.keymap.set("n", leader .. "hs", gitsigns.stage_hunk, desc("Stage Hunk"))
    vim.keymap.set("v", leader .. "hs", gitsigns.stage_hunk, desc("Stage Hunk"))
    vim.keymap.set("n", leader .. "hS", gitsigns.stage_buffer, desc("Stage Buffer"))
    -- z

    -- /-\
  end
end

function M.init()
  gitsigns.setup({
    numhl = true,
    current_line_blame_opts = {
      delay = 100,
    },
    on_attach = on_attach,
  })
end

return M
