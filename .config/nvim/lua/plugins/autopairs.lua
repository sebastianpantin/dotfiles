local M = {
	"windwp/nvim-autopairs",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	event = "VeryLazy",
}

M.config = function()
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")

	require("nvim-autopairs").setup({
    check_ts = true, -- enable treesitter
    ts_config = {
      lua = { "string", "source" }, -- don't add pairs in lua string treesitter nodes
      javascript = { "string", "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
      java = false, -- don't check treesitter on java
    },
    disable_filetype = { "TelescopePrompt" },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },	
	})
	require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
