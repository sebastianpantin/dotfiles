local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local icons = require("lazyvim.config").icons

      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },
        symbols = { error = icons.diagnostics.Error, warn = icons.diagnostics.Warn },
        colored = true,
        update_in_insert = false,
        always_visible = true,
      }

      local diff = {
        "diff",
        colored = false,
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        }, -- changes diff symbols
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

      return {
        options = {
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "alpha", "dashboard", "lazy" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { branch, diagnostics },
          lualine_c = { filetype },
          lualine_x = { diff, spaces, "encoding" },
          lualine_y = { location },
          lualine_z = { "progress" },
        },
      }
    end,
  },
}
