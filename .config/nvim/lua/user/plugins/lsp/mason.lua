local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

local lsp_servers = {
  "cssls",
  "html",
  "tsserver",
  "csharp_ls",
  "sumneko_lua",
  "yamlls",
  "pyright",
  "jedi_language_server",
}

local settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)

mason_lspconfig.setup({
  ensure_installed = lsp_servers,
  automatic_installation = true,
})

local null_ls_servers = {
  "prettier",
  "stylua",
  "eslint_d",
  "black",
  "flake8",
}

mason_null_ls.setup({
  ensure_installed = null_ls_servers,
  automatic_installation = true,
})
