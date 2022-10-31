local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
	return
end

catppuccin.setup({
	flavour = "frappe", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "frappe",
	},
	compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
	dim_inactive = {
		enabled = true,
		shade = "dark",
		percentage = 0.15,
	},
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = { "italic" },
		strings = {},
		variables = { "italic" },
		numbers = {},
		booleans = { "italic" },
		properties = { "italic" },
		types = {},
		operators = {},
	},
	color_overrides = {},
	custom_highlights = {},
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		telescope = true,
		treesitter = true,
		dashboard = true,
		bufferline = {
			enable = true,
			italics = true,
			bolds = true,
		},
		indent_blankline = {
			enable = true,
			colored_indent_levels = true,
		},
    fidget = true,
	},
})
