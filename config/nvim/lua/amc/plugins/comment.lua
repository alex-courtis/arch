local comment = require("nvim_comment")

comment.setup({
  create_mappings = true,
  line_mapping = "<BS>cc",
  operator_mapping = "<BS>c",
  comment_chunk_text_object = "ic",
})
