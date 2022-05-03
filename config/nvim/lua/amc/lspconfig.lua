local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.ccls.setup({
	capabilities = capabilities,
	init_options = {
		compilationDatabaseDirectory = "build",
		clang = {
			excludeArgs = {
				"-Werror",
			},
		},
	},
})
