local M = {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.luasnippets_path or "" })
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}

function M.config()
	local luasnip = require("luasnip")

	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI"
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			if
				require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
				and not require("luasnip").session.jump_active
			then
				require("luasnip").unlink_current()
			end
		end,
	})	
end

return M
