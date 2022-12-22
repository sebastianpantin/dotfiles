local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local rust_tools_status, rust_tools = pcall(require, "rust-tools")
if not rust_tools_status then
	return
end

local lsp_servers = {
	"cssls",
	"html",
	"tsserver",
	"csharp_ls",
	"sumneko_lua",
	"yamlls",
	"jedi_language_server",
	"terraformls",
	"rust_analyzer",
	"dockerls",
	"taplo",
}

mason_lspconfig.setup({
	ensure_installed = lsp_servers,
	automatic_installation = true,
})

local opts = {
	on_attach = require("user.plugins.lsp.handlers").on_attach,
	capabilities = require("user.plugins.lsp.capabilities").capabilities,
}

mason_lspconfig.setup_handlers({

	--- Default handler
	function(server_name)
		lspconfig[server_name].setup(opts)
	end,

	["sumneko_lua"] = function()
		lspconfig["sumneko_lua"].setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
	end,
	["rust_analyzer"] = function()
		rust_tools.setup({
			server = {
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
			},
		})
	end,
})
