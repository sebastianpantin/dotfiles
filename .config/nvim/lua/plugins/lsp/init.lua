local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
    "williamboman/mason-lspconfig.nvim",
		"jayp0521/mason-null-ls.nvim",
		"jose-elias-alvarez/null-ls.nvim",
		"williamboman/mason.nvim",
		"glepnir/lspsaga.nvim",
    "j-hui/fidget.nvim",
    "simrat39/rust-tools.nvim",
		"jose-elias-alvarez/typescript.nvim",
	},
}

M.config = function()
  require("mason")
	require("null-ls")
	require("plugins.lsp.diagnostics").setup()
	require("plugins.lsp.mason_lspconfig")
	require("plugins.lsp.lspsaga").setup()
	require("plugins.lsp.mason_null_ls")


end

return M
