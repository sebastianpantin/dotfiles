return {
    { -- indentation guides
        "lukas-reineke/indent-blankline.nvim",
        event = "UIEnter",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
        main = "ibl",
    },
    { -- Nerdfont filetype icons
        -- https://www.reddit.com/r/neovim/comments/12lf0ke/comment/jg6idvr/
        "nvim-tree/nvim-web-devicons",
        opts = {
            default = true, -- use default icon as fallback
            override = {
                -- filetypes
                applescript = { icon = "", color = "#7f7f7f", name = "Applescript" },
                bib = { icon = "", color = "#6e9b2a", name = "BibTeX" },
                http = { icon = "󰴚", name = "HTTP request" }, -- for rest.nvim
                -- give plugins icons for my status line components
                gitignore = { icon = "", name = "gitignore" },
                ipython = { icon = "󰌠", name = "ipython" },
                checkhealth = { icon = "󰩂", name = ":checkhealth" },
                noice = { icon = "󰎟", name = "noice.nvim" },
                lazy = { icon = "󰒲", name = "lazy.nvim" },
                mason = { icon = "", name = "mason.nvim" },
                lspinfo = { icon = "󰒕", name = "lspinfo" },
                TelescopePrompt = { icon = "", name = "Telescope" },
            },
        },
    },
    { -- emphasized undo/redos
        "tzachar/highlight-undo.nvim",
        keys = { "u", "U" },
        opts = {
            duration = 250,
            undo = {
                lhs = "u",
                map = "silent undo",
                opts = { desc = "󰕌 Undo" },
            },
            redo = {
                lhs = "U",
                map = "silent redo",
                opts = { desc = "󰑎 Redo" },
            },
        },
    },
    { -- Better input/selection fields
        "stevearc/dressing.nvim",
        keys = {
            { "<Tab>",   "j", ft = "DressingSelect" },
            { "<S-Tab>", "k", ft = "DressingSelect" },
        },
        -- lazy load triggers
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            input = {
                insert_only = false, -- enable normal mode
                relative = "editor",
                title_pos = "left",
                min_width = { 0.4, 60 },
                win_options = { winblend = 0 },
            },
            select = {
                backend = { "builtin" },
                trim_prompt = true, -- trailing `:`
                builtin = {
                    show_numbers = false,
                    relative = "cursor",
                    max_width = 80,
                    min_width = 20,
                    max_height = 20,
                    min_height = 3,
                    win_options = { winblend = 0 },
                },
                telescope = {
                    layout_config = {
                        horizontal = { width = 0.8, height = 0.6 },
                    },
                },
                get_config = function(opts)
                    if opts.kind == "github_issue" then
                        return { backend = "telescope" }
                    end
                end,
            },
        },
    },
}
