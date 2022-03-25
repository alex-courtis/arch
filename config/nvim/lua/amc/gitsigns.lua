require('gitsigns').setup{

  on_attach = function(bufnr)

    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<space>j', function()
      if vim.wo.diff then
        return '<space>j'
      else
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end
    end, {expr=true})

    map('n', '<space>k', function()
      if vim.wo.diff then
        return '<space>k'
      else
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<BS>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<BS>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<BS>hS', gs.stage_buffer)
    map('n', '<BS>hu', gs.undo_stage_hunk)
    map('n', '<BS>hR', gs.reset_buffer)
    map('n', '<BS>hp', gs.preview_hunk)
    map('n', '<BS>hb', function() gs.blame_line{full=true} end)
    map('n', '<BS>hl', gs.toggle_current_line_blame)
    map('n', '<BS>hd', gs.diffthis)
    map('n', '<BS>hD', function() gs.diffthis('~') end)
    map('n', '<BS>ht', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

