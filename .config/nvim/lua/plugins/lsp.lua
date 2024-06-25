local servers = {
	"lua_ls",
	"pylsp",
	"ruff_lsp",
	"csharp_ls",
	"dockerls",
	"terraformls",
	"yamlls",
	"fsautocomplete",
	"vtsls",
	"eslint",
}

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"RRethy/vim-illuminate",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Set up Mason before anything else
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			-- Quick access via keymap
			require("helpers.keys").map("n", "<leader>M", "<cmd>Mason<cr>", "Show Mason")

			-- Neodev setup before LSP config
			require("neodev").setup()

			-- Set up cool signs for diagnostics
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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
				update_in_insert = false,
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

			-- This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(client, bufnr)
				local lsp_map = require("helpers.keys").lsp_map
				local lsp_utils = require("plugins.lspsettings.utils")
				local telescope = require("telescope.builtin")

				lsp_map("<leader>cr", vim.lsp.buf.rename, bufnr, "Rename symbol")
				lsp_map("<leader>ca", vim.lsp.buf.code_action, bufnr, "Code action")
				lsp_map("<leader>cy", vim.lsp.buf.type_definition, bufnr, "Type definition")
				lsp_map("<leader>ls", telescope.lsp_document_symbols, bufnr, "Document symbols")

				lsp_map("gd", telescope.lsp_definitions, bufnr, "Goto Definition")
				lsp_map("gr", telescope.lsp_references, bufnr, "Goto References")
				lsp_map("gI", vim.lsp.buf.implementation, bufnr, "Goto Implementation")
				lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
				lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })

				lsp_map("<leader>cf", "<cmd>Format<cr>", bufnr, "Format")

				if client.name == "vtsls" then
					client.server_capabilities.documentFormattingProvider = false
					local ts_mappings = lsp_utils.generate_ts_mappings(client.name)
					lsp_map("gd", ts_mappings.go_to_source_definition, bufnr, "Goto Definition")
					lsp_map("<leader>cmi", ts_mappings.add_missing_imports, bufnr, "Add missing imports")
					lsp_map("<leader>coi", ts_mappings.organize_imports, bufnr, "Organize imports")
					lsp_map("<leader>cri", ts_mappings.remove_unused_imports, bufnr, "Remove unused imports")
				end

				if client.name == "ruff_lsp" then
					client.server_capabilities.hoverProvider = false
				end

				if client.supports_method("textDocument/inlayHint") then
					vim.g.inlay_hints_visible = true
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end

				-- Attach and configure vim-illuminate
				require("illuminate").on_attach(client)
			end

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
			if not lspconfig_status_ok then
				return
			end

			for _, server in pairs(servers) do
				local opts = {
					on_attach = on_attach,
					capabilities = capabilities,
				}

				server = vim.split(server, "@")[1]

				local require_ok, conf_opts = pcall(require, "plugins.lspsettings." .. server)
				if require_ok then
					opts = vim.tbl_deep_extend("force", conf_opts, opts)
				end

				lspconfig[server].setup(opts)
			end
		end,
	},
	{
		"yioneko/nvim-vtsls",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		dependencies = { "nvim-lspconfig" },
	},
}
