local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

M.config = function()
  local wk = require("which-key")
  local config = {
    setup = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        presets = {
          operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      key_labels = {
        ["<leader>"] = "SPC",
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = false, -- show help message on the command line when the popup is visible
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
    },
    opts = {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },
    vopts = {
      mode = "v", -- VISUAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },
    vmappings = {
      ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', "Comment" },
      s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
    },
    mappings = {
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Action" },
      b = { "<cmd>Telescope buffers<cr>", "Buffers" },
      e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
      v = { "<cmd>vsplit<cr>", "vsplit" },
      h = { "<cmd>split<cr>", "split" },
      w = { "<cmd>w<CR>", "Write" },
      q = { '<cmd>lua require("user.core.functions").smart_quit()<CR>', "Quit" },
      ["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
      c = { "<cmd>Bdelete!<CR>", "Close Buffer" },

      P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },

      p = {
        name = "Plugins",
        i = { "<cmd>Lazy install<cr>", "Install" },
        s = { "<cmd>Lazy sync<cr>", "Sync" },
        S = { "<cmd>Lazy clear<cr>", "Status" },
        c = { "<cmd>Lazy clean<cr>", "Clean" },
        u = { "<cmd>Lazy update<cr>", "Update" },
        p = { "<cmd>Lazy profile<cr>", "Profile" },
        l = { "<cmd>Lazy log<cr>", "Log" },
        d = { "<cmd>Lazy debug<cr>", "Debug" },
      },

      f = {
        name = "Find",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
        s = { "<cmd>Telescope grep_string<cr>", "Find String" },
        h = { "<cmd>Telescope help_tags<cr>", "Help" },
        H = { "<cmd>Telescope highlights<cr>", "Highlights" },
        l = { "<cmd>Telescope resume<cr>", "Last Search" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
      },

      l = {
        name = "LSP",
        a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
        w = {
          "<cmd>Telescope lsp_workspace_diagnostics<cr>",
          "Workspace Diagnostics",
        },
        f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { "<cmd>Mason<cr>", "Installer Info" },
        j = {
          "<cmd>Lspsaga diagnostic_jump_next<CR>",
          "Next Diagnostic",
        },
        k = {
          "<cmd>Lspsaga diagnostic_jump_prev<cr>",
          "Prev Diagnostic",
        },
        o = { "<cmd>LSoutlineToggle<cr>", "Outline" },
        q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
        r = { "<cmd>Lspsaga rename<cr>", "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = {
          "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
          "Workspace Symbols",
        },
        t = { '<cmd>lua require("user.functions").toggle_diagnostics()<cr>', "Toggle Diagnostics" },
      },

      s = {
        name = "Surround",
        ["."] = { "<cmd>lua require('surround').repeat_last()<cr>", "Repeat" },
        a = { "<cmd>lua require('surround').surround_add(true)<cr>", "Add" },
        d = { "<cmd>lua require('surround').surround_delete()<cr>", "Delete" },
        r = { "<cmd>lua require('surround').surround_replace()<cr>", "Replace" },
        q = { "<cmd>lua require('surround').toggle_quotes()<cr>", "Quotes" },
        b = { "<cmd>lua require('surround').toggle_brackets()<cr>", "Brackets" },
      },

      S = {
        name = "SnipRun",
        c = { "<cmd>SnipClose<cr>", "Close" },
        f = { "<cmd>%SnipRun<cr>", "Run File" },
        i = { "<cmd>SnipInfo<cr>", "Info" },
        m = { "<cmd>SnipReplMemoryClean<cr>", "Mem Clean" },
        r = { "<cmd>SnipReset<cr>", "Reset" },
        t = { "<cmd>SnipRunToggle<cr>", "Toggle" },
        x = { "<cmd>SnipTerminate<cr>", "Terminate" },
      },

      T = {
        name = "Treesitter",
        h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight" },
        p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
        r = { "<cmd>TSToggle rainbow<cr>", "Rainbow" },
      },
    },
  }
  wk.setup(config.setup)
  wk.register(config.mappings, config.opts)
  wk.register(config.vmapping, config.vopts)
end

return M
