return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
		},
		config = function()
			require("telescope").load_extension("aerial")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				},
				extensions = {
					aerial = {
						show_nesting = {
							["_"] = false,
							json = true,
							yaml = true,
						},
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")

			local map = require("helpers.keys").map
			map("n", "<leader>fr", require("telescope.builtin").oldfiles, "Recently opened")
			map("n", "<leader>ff", require("telescope.builtin").find_files, "Files")
			map("n", "<leader>fp", ":Telescope workspaces <CR>", "Workspaces")
			map("n", "<leader>sh", require("telescope.builtin").help_tags, "Help")
			map("n", "<leader>sw", require("telescope.builtin").grep_string, "Current word")
			map("n", "<leader>sg", require("telescope.builtin").live_grep, "Grep")
			map("n", "<leader>fs", ":Telescope aerial <CR>", "Symbols")
			map("n", "<leader>sd", require("telescope.builtin").diagnostics, "Diagnostics")

			map("n", "<C-p>", require("telescope.builtin").keymaps, "Search keymaps")
		end,
	},
}
