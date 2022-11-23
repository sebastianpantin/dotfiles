local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

local settings = {
	ui = {
		border = "rounded",
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

mason.setup(settings)
