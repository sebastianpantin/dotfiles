local M = {
	"ahmedkhalf/project.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
}

M.config = function()
	require("project_nvim").setup({
    active = true,
    on_config_done = nil,
		manual_mode = false,
		detection_methods = { "pattern" },
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pyproject.toml", "pubspec.yaml" },
		ignore_lsp = {},
		show_hidden = false,
		silent_chdir = true,
		datapath = vim.fn.stdpath("data"),
	})

	require("telescope").load_extension("projects")
end

return M
