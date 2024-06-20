return {
	-- Move stuff with <M-j> and <M-k> in both normal and visual mode
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
	},
	{
		"nmac427/guess-indent.nvim",
		opts = {
			auto_cmd = true,
		},
	},
}
