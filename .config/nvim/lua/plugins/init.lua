return {
	-- Lua dev
	"nvim-lua/plenary.nvim",
	"nvim-lua/popup.nvim",

	-- Formatting/Linting
	"jose-elias-alvarez/null-ls.nvim",
	"jayp0521/mason-null-ls.nvim",

	-- Highlight function arguments
	{
		"m-demare/hlargs.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("hlargs").setup()
		end,
		event = "BufReadPre",
	},

	-- Add/change/delete surrounding delimiter pairs
	{
		"kylechui/nvim-surround",
		version = "*",
		config = true,
		event = "VeryLazy",
	},
}
