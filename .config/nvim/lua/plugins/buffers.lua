local M = {
  "akinsho/bufferline.nvim",
  tag = "v3.1.0",
  dependencies = {"kyazdani42/nvim-web-devicons", "moll/vim-bbye" },
  event = "BufEnter",
}

M.config = function()
  bufferline = require("bufferline")
  bufferline.setup({
    options = {
      numbers = "none",
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d",
      left_mouse_command = "buffer %d",
      indicator = { icon = "│" },
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 30,
      max_prefix_length = 30,
      tab_size = 21,
      diagnostics = false,
      diagnostics_update_in_insert = false,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      separator_style = "thin",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
    },
    highlights = require("catppuccin.groups.integrations.bufferline").get(),
  })
  
end
return M
