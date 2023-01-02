local M = {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
  dependencies = {
    {
      "nmac427/guess-indent.nvim",
		  config = function()
			  require("guess-indent").setup({})
		  end
    }, 
  },
	config = {
		space_char_blankline = " ",
		buftype_exclude = { "telescope", "terminal", "nofile", "quickfix", "prompt" },
		filetype_exclude = {
			"help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",	
		},
	},
}

return M
