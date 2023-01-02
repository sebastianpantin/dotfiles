local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	event = "VeryLazy",
}

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

M.config = function()
  local icons = require "config.icons"

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
    colored = true,
    update_in_insert = false,
    always_visible = true,
  }

  local diff = {
    "diff",
    colored = false,
    symbols = { added = icons.git.Add .. " ", modified = icons.git.Mod .. " ", removed = icons.git.Remove .. " " }, -- changes diff symbols
    cond = hide_in_width,
  }

  local filetype = {
    "filetype",
    icons_enabled = false,
    icon = nil,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local location = {
    "location",
    padding = 0,
  }

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end


  require("lualine").setup({
    options = {
      theme = "catppuccin",
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "toggleterm" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { branch, diagnostics },
      lualine_c = { filetype },
      lualine_x = { diff, spaces, "encoding" },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {}, 
  })
end
return M


