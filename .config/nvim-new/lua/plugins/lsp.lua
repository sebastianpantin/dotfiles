local icons = require("core.icons").icons

vim.g.myLsps = {
    "lua_ls",
    "ruff_lsp",
    "pylsp"
}

--------------------------------------------------------------------------------

---@class lspConfiguration see :h lspconfig-setup
---@field settings? table <string, table>
---@field root_dir? function(filename, bufnr)
---@field filetypes? string[]
---@field init_options? table <string, string|table|boolean>
---@field on_attach? function(client, bufnr)
---@field capabilities? table <string, string|table|boolean|function>
---@field cmd? string[]
---@field autostart? boolean

---@type table<string, lspConfiguration>
local serverConfigs = {}
for _, lsp in pairs(vim.g.myLsps) do
    serverConfigs[lsp] = {}
end

--------------------------------------------------------------------------------

-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    local lsp_map = require("helpers.keys").lsp_map

    lsp_map("<leader>cr", vim.lsp.buf.rename, bufnr, "Rename symbol")
    lsp_map("<leader>ca", vim.lsp.buf.code_action, bufnr, "Code action")
    lsp_map("<leader>cd", vim.lsp.buf.type_definition, bufnr, "Type definition")
    lsp_map("<leader>cs", require("telescope.builtin").lsp_document_symbols, bufnr, "Document symbols")

    lsp_map("gd", vim.lsp.buf.definition, bufnr, "Goto Definition")
    lsp_map("gr", require("telescope.builtin").lsp_references, bufnr, "Goto References")
    lsp_map("gI", vim.lsp.buf.implementation, bufnr, "Goto Implementation")
    lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
    lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")

    -- Attach and configure vim-illuminate
    require("illuminate").on_attach(client)

    if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pylsp
        client.server_capabilities.hoverProvider = false
    end
end


--------------------------------------------------------------------------------

-- LUA

serverConfigs.lua_ls = {
    -- DOCS https://luals.github.io/wiki/settings/
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
                keywordSnippet = "Replace",
                displayContext = 6,
                postfix = ".", -- useful for `table.insert` and the like
            },
            diagnostics = {
                globals = { "vim" },            -- when contributing to nvim plugins missing a .luarc.json
                disable = { "trailing-space" }, -- formatter already does that
            },
            hint = {
                enable = true, -- enabled inlay hints
                setType = true,
                arrayIndex = "Disable",
            },
            workspace = { checkThirdParty = false }, -- FIX https://github.com/sumneko/lua-language-server/issues/679#issuecomment-925524834
        },
    },
    on_attach = on_attach
}

--------------------------------------------------------------------------------
-- PYTHON

-- DOCS https://github.com/astral-sh/ruff-lsp#settings
serverConfigs.ruff_lsp = {
    -- Disable hover in favor of pylsp
    on_attach = on_attach

}

serverConfigs.pylsp = {
    settings = {
        pylsp = {
            plugins = {
                ruff = { enabled = false },
                autopep8 = { enabled = false },
                flake8 = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
            },
        },
    },
    on_attach = on_attach
}

--------------------------------------------------------------------------------

local function setupAllLsps()
    -- Enable snippets-completion (nvim_cmp) and folding (nvim-ufo)
    local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
    lspCapabilities = require("cmp_nvim_lsp").default_capabilities(lspCapabilities)
    lspCapabilities.textDocument.completion.completionItem.snippetSupport = true

    for lsp, serverConfig in pairs(serverConfigs) do
        serverConfig.capabilities = lspCapabilities
        require("lspconfig")[lsp].setup(serverConfig)
    end
end

local function lspCurrentTokenHighlight()
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local capabilities = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities
            if not capabilities.documentHighlightProvider then return end

            vim.api.nvim_create_autocmd("CursorHold", {
                callback = vim.lsp.buf.document_highlight,
                buffer = args.buf,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = vim.lsp.buf.clear_references,
                buffer = args.buf,
            })
        end,
    })
    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        callback = function()
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { underdashed = true }) -- definition
            vim.api.nvim_set_hl(0, "LspReferenceRead", { underdotted = true }) -- reference
            vim.api.nvim_set_hl(0, "LspReferenceText", {})             -- too much noise, as is underlines e.g. strings
        end,
    })
end

local function lspSignatureSettings()
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
    -- INFO this needs to be disabled for noice.nvim
    -- vim.lsp.handlers["textDocument/hover"] =
    -- vim.lsp.with(vim.lsp.handlers.hover, { border = u.borderStyle })
end



return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "j-hui/fidget.nvim",
                tag = "legacy",
                event = "LspAttach",
            },
            "folke/neodev.nvim",
            "RRethy/vim-illuminate",
            "hrsh7th/cmp-nvim-lsp",
        },
        init = function ()
            setupAllLsps()
            lspCurrentTokenHighlight()
            lspSignatureSettings()
        end,
        config = function()
            -- Set up Mason before anything else
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = myLsps,
                automatic_installation = true,
            })

            -- Quick access via keymap
            require("helpers.keys").map("n", "<leader>cm", "<cmd>Mason<cr>", "Show Mason")

            -- Neodev setup before LSP config
            require("neodev").setup()

            -- Turn on LSP status information
            require("fidget").setup()

            -- Set up cool signs for diagnostics
            local signs = {
                Error = icons.diagnostics.Error,
                Warn = icons.diagnostics.Warn,
                Hint = icons.diagnostics.Hint,
                Info = icons.diagnostics.Hint
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Diagnostic config
            local config = {
                virtual_text = false,
                signs = {
                    active = signs,
                },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }
            vim.diagnostic.config(config)

        end,
    },
}
