for _, mode in pairs({ "n", "i", "c", "v", "x", "s", "o", }) do
  for _, leader in pairs({ false, true, }) do
    for _, silent in pairs({ false, true, }) do
      for _, buffer in pairs({ false, true, }) do
        print(([[
  ---@param lhs string
  ---@param rhs function|string%s
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  %s%s%s%s = function(lhs, rhs, %sdesc, opts) map%s("%s", lhs, rhs, vim.tbl_extend("keep", opts or {}, { desc = desc, silent = %s,%s })) end,
]]):
        format(
          buffer and "\n  ---@param buffer number" or "",
          mode, silent and "s" or "_", leader and "l" or "_", buffer and "b" or "_",
          buffer and "buffer, " or "",
          leader and "l" or "_", mode,
          silent and "true" or "false",
          buffer and " buffer = buffer," or ""
        ))
      end
    end
  end
end
