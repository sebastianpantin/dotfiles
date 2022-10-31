-- Auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins_setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	-- Plugin manager
	use("wbthomason/packer.nvim")

	-- Startup time
	use("lewis6991/impatient.nvim")

	-- Lua dev
	use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins
	use("nvim-lua/popup.nvim")

	-- LSP manager
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- LSP config
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use({ "glepnir/lspsaga.nvim", branch = "main" }) -- enhanced lsp uis
	use("j-hui/fidget.nvim")
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("petobens/poet-v")

	-- Formatting & linting
	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")

	-- Load luasnips + cmp related stuff in insert mode only
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion
	use({ "rafamadriz/friendly-snippets", module = { "cmp", "cmp_nvim_lsp" }, event = "InsertEnter" })

	use({
		"hrsh7th/nvim-cmp",
		after = "friendly-snippets",
		config = function()
			require("user.plugins.nvim-cmp")
		end,
	})
	use({
		"L3MON4D3/LuaSnip",
		wants = "friendly-snippets",
		after = "nvim-cmp",
		config = function()
			require("user.plugins.luasnip")
		end,
	})

	-- Autocompletion
	use({ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" }) -- vim lua completions
	use({ "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" }) -- for autocompletion
	use({ "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" }) -- buffer completions
	use({ "hrsh7th/cmp-path", after = "cmp-buffer" }) -- path completions

	-- Snippet

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	use("kylechui/nvim-surround")

	-- Telescope/Fuzzy finder
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

	-- Colorizer
	use("NvChad/nvim-colorizer.lua")

	-- Colorscheme
	use({ "catppuccin/nvim", as = "catppuccin", run = ":CatppuccinCompile" })

	-- Icons
	use("kyazdani42/nvim-web-devicons")

	-- Bufferline
	use({
		"akinsho/bufferline.nvim",
		tag = "v3.*",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Status line
	use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

	-- Greeter
	use({ "goolord/alpha-nvim" })

	-- File explorer
	use({ "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" } })

	-- Comment
	use("numToStr/Comment.nvim")
	use("folke/todo-comments.nvim")

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- Auto closing
	use({
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
		config = function()
			require("user.plugins.autopairs")
		end,
	})
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })

	-- Project
	use("ahmedkhalf/project.nvim")

	-- Indent line
	use("lukas-reineke/indent-blankline.nvim")

	use({
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	})

	-- Keybinding
	use({ "folke/which-key.nvim" })

	if packer_bootstrap then
		require("packer").sync()
	end
end)
