local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

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
