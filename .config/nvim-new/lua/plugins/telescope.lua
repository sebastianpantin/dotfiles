local Util = require("util")

local kind_filter = {
    default = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        -- "Package", -- remove package since luals uses it for control flow structures
        "Property",
        "Struct",
        "Trait",
    },
}

local function get_kind_filter(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
    local ft = vim.bo[buf].filetype
    if kind_filter == false then
        return
    end
    if kind_filter[ft] == false then
        return
    end
    ---@diagnostic disable-next-line: return-type-mismatch
    return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
end


------------------------------------------------------------------------------------------------------------------------------


return {
    { -- fuzzy finder
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<leader>,",       "<cmd>Telescope buffers show_all_buffers=true<cr>",                desc =
            "Switch Buffer" },
            { "<leader>/",       Util.telescope("live_grep"),                                       desc =
            "Grep (root dir)" },
            { "<leader>:",       "<cmd>Telescope command_history<cr>",                              desc =
            "Command History" },
            { "<leader><space>", Util.telescope("files"),                                           desc =
            "Find Files (root dir)" },
            -- find
            { "<leader>fb",      "<cmd>Telescope buffers<cr>",                                      desc = "Buffers" },
            { "<leader>fc",      Util.telescope.config_files(),                                     desc =
            "Find Config File" },
            { "<leader>ff",      Util.telescope("files"),                                           desc =
            "Find Files (root dir)" },
            { "<leader>fF",      Util.telescope("files", { cwd = false }),                          desc =
            "Find Files (cwd)" },
            { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                                     desc = "Recent" },
            { "<leader>fR",      Util.telescope("oldfiles", { cwd = vim.loop.cwd() }),              desc = "Recent (cwd)" },
            -- git
            { "<leader>gc",      "<cmd>Telescope git_commits<CR>",                                  desc = "commits" },
            { "<leader>gs",      "<cmd>Telescope git_status<CR>",                                   desc = "status" },
            -- search
            { '<leader>s"',      "<cmd>Telescope registers<cr>",                                    desc = "Registers" },
            { "<leader>sa",      "<cmd>Telescope autocommands<cr>",                                 desc =
            "Auto Commands" },
            { "<leader>sb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",                    desc = "Buffer" },
            { "<leader>sc",      "<cmd>Telescope command_history<cr>",                              desc =
            "Command History" },
            { "<leader>sC",      "<cmd>Telescope commands<cr>",                                     desc = "Commands" },
            { "<leader>sd",      "<cmd>Telescope diagnostics bufnr=0<cr>",                          desc =
            "Document diagnostics" },
            { "<leader>sD",      "<cmd>Telescope diagnostics<cr>",                                  desc =
            "Workspace diagnostics" },
            { "<leader>sg",      Util.telescope("live_grep"),                                       desc =
            "Grep (root dir)" },
            { "<leader>sG",      Util.telescope("live_grep", { cwd = false }),                      desc = "Grep (cwd)" },
            { "<leader>sh",      "<cmd>Telescope help_tags<cr>",                                    desc = "Help Pages" },
            { "<leader>sH",      "<cmd>Telescope highlights<cr>",                                   desc =
            "Search Highlight Groups" },
            { "<leader>sk",      "<cmd>Telescope keymaps<cr>",                                      desc = "Key Maps" },
            { "<leader>sM",      "<cmd>Telescope man_pages<cr>",                                    desc = "Man Pages" },
            { "<leader>sm",      "<cmd>Telescope marks<cr>",                                        desc = "Jump to Mark" },
            { "<leader>so",      "<cmd>Telescope vim_options<cr>",                                  desc = "Options" },
            { "<leader>sR",      "<cmd>Telescope resume<cr>",                                       desc = "Resume" },
            { "<leader>sw",      Util.telescope("grep_string", { word_match = "-w" }),              desc =
            "Word (root dir)" },
            { "<leader>sW",      Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
            { "<leader>sw",      Util.telescope("grep_string"),                                     mode = "v",
                                                                                                                                          desc =
                "Selection (root dir)" },
            { "<leader>sW",      Util.telescope("grep_string", { cwd = false }),                    mode = "v",
                                                                                                                                          desc =
                "Selection (cwd)" },
            { "<leader>uC",      Util.telescope("colorscheme", { enable_preview = true }),
                                                                                                        desc =
                "Colorscheme with preview" },
            {
                "<leader>ss",
                function()
                    require("telescope.builtin").lsp_document_symbols({
                        symbols = get_kind_filter(),
                    })
                end,
                desc = "Goto Symbol",
            },
            {
                "<leader>sS",
                function()
                    require("telescope.builtin").lsp_dynamic_workspace_symbols({
                        symbols = get_kind_filter(),
                    })
                end,
                desc = "Goto Symbol (Workspace)",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        opts = function()
            local actions = require("telescope.actions")

            local open_with_trouble = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
            end
            local open_selected_with_trouble = function(...)
                return require("trouble.providers.telescope").open_selected_with_trouble(...)
            end
            local find_files_no_ignore = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                Util.telescope("find_files", { no_ignore = true, default_text = line })()
            end
            local find_files_with_hidden = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                Util.telescope("find_files", { hidden = true, default_text = line })()
            end

            return {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    -- open files in the first window that is an actual file.
                    -- use the current window if no other window is available.
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == "" then
                                return win
                            end
                        end
                        return 0
                    end,
                    mappings = {
                        i = {
                            ["<c-t>"] = open_with_trouble,
                            ["<a-t>"] = open_selected_with_trouble,
                            ["<a-i>"] = find_files_no_ignore,
                            ["<a-h>"] = find_files_with_hidden,
                            ["<C-Down>"] = actions.cycle_history_next,
                            ["<C-Up>"] = actions.cycle_history_prev,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                        },
                        n = {
                            ["q"] = actions.close,
                        },
                    },
                },
            }
        end,
    },
    { -- Icon Picker
        "nvim-telescope/telescope-symbols.nvim",
        keys = {
            {
                "<D-ö>",
                mode = { "n", "i" },
                function()
                    require("telescope.builtin").symbols {
                        sources = { "nerd", "math" },
                        layout_config = { horizontal = { width = 0.35, height = 0.55 } },
                    }
                end,
                desc = " Icon Picker",
            },
        },
    },
    { -- better recent files
        "smartpde/telescope-recent-files",
        dependencies = "nvim-telescope/telescope.nvim",
        config = function() require("telescope").load_extension("recent_files") end,
        keys = {
            {
                "fr",
                function() require("telescope").extensions.recent_files.pick() end,
                desc = " Recent Files",
            },
        },
    },
    { -- better sorting algorithm + fzf syntax
        "nvim-telescope/telescope-fzf-native.nvim",
        config = function() require("telescope").load_extension("fzf") end,
        build = "make",
    },
}
