for _, mode in ipairs({ "n", "i", "c", "v", "x", "s", "o", }) do
  for _, leader in ipairs({ false, true, }) do
    for _, silent in ipairs({ false, true, }) do
      print(([[
  ---@param lhs string
  ---@param rhs function|string
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  %s%s%s = function(lhs, rhs, desc, opts) map%s("%s", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = %s, })) end,
]]):
      format(
        mode, silent and "s" or "_", leader and "l" or "_",
        leader and "l" or "_", mode,
        silent and "true" or "false"
      ))
    end
  end
end
