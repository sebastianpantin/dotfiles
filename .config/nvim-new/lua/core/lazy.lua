-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local ok, lazy = pcall(require, "lazy")
if not ok then
	return
end

-- We have to set the leader key here for lazy.nvim to work
require("helpers.keys").set_leader(" ")

-- Load plugins from specifications
-- (The leader key must be set before this)
lazy.setup("plugins", {
	defaults = { lazy = false },
	ui = {
		wrap = true,
		size = { width = 1, height = 0.92 }, -- full sized, except statusline
	},
	checker = {
		enabled = true, -- automatically check for plugin updates
		notify = false, -- done on my own to use minimum condition for less noise
		frequency = 60 * 60 * 24, -- = 1 day
	},
	diff = { cmd = "browser" }, -- view diffs with "d" in the browser
	change_detection = { notify = false },
	readme = { enabled = false },
	install = { colorscheme = { "tokyonight", "catppuccin" } },
	performance = {
		rtp = {
			-- disable unused builtin plugins from neovim
			disabled_plugins = {
				"man",
				"matchparen",
				"matchit",
				"netrw",
				"netrwPlugin",
				"gzip",
				"zip",
				"tar",
				"tarPlugin",
				"tutor",
				"rplugin",
				"health",
				"tohtml",
				"zipPlugin",
			},
		},
	},
})

-- Might as well set up an easy-access keybinding

require("helpers.keys").map("n", "<leader>L", lazy.show, "Show Lazy")
