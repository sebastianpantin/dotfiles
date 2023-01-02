local M = {
	"williamboman/mason.nvim",
}

function M.config()
  local settings = {
    ui = {
      border = "rounded",
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
  }
	require("mason").setup(settings)
end

return M
