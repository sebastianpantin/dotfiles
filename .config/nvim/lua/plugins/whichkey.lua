return {
	{
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")
			wk.setup({
				plugins = {
					marks = true,
					registers = true,
				  	spelling = {
						enabled = true,
						suggestions = 20,
				  	},
				  	presets = {
						operators = false,
						motions = false,
						text_objects = false,
						windows = false,
						nav = false,
						z = false,
						g = false,
				  	},
				},
			})
			wk.register(
				{
					["<leader>"] = {
						f = { name = "File" },
						d = { name = "Delete/Close" },
						q = { name = "Quit" },
						s = { name = "Search" },
						l = { name = "LSP" },
						u = { name = "UI" },
						b = { name = "Buffer" },
						g = { name = "Git" },
						c = { name = "Code" },
						v = { "<cmd>vsplit<CR>", "Split" }
					}
				}
			)
		end
	}
}
