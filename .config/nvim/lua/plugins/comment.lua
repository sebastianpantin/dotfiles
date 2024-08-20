return {
	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				event = "VeryLazy",
			},
		},
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
		config = function(_, opts)
			require("mini.comment").setup(opts)
		end,
	},
}
