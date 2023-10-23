local linters = {
	lua = {},
	css = {},
	sh = {},
	markdown = {},
	yaml = { "yamllint" },
	python = { "mypy", "flake8", "ruff" },
	gitcommit = {},
	json = {},
	javascript = {},
	typescript = {},
	toml = {},
	applescript = {},
	bib = {},
}

local formatters = {
	javascript = { "prettier" },
	typescript = { "prettier" },
	json = {},
	jsonc = {},
	lua = { "stylua" },
	python = { "ruff_format", "ruff_fix" },
	yaml = { "yamlfix" },
	html = { "prettier" },
	markdown = {},
	css = { "prettier" },
	sh = { "shfmt" },
	bib = {},
	["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
}

-- filetypes that should use lsp formatting
local lspFormatting = {
	"toml",
}

local extraInstalls = {
	"ruff", -- since ruff_format and ruff_fix aren't the real names
}

local dontInstall = {
	-- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
	"stylelint",
	-- not real formatters, but pseudo-formatters from conform.nvim
	"trim_whitespace",
	"trim_newlines",
	"squeeze_blanks",
	"injected",
	"ruff_format",
	"ruff_fix",
}

--given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
---list of all tools that need to be auto-installed
---@param myLinters object[]
---@param myFormatters object[]
---@param extraTools string[]
---@param ignoreTools string[]
---@return string[] tools
---@nodiscard
local function toolsToAutoinstall(myLinters, myFormatters, extraTools, ignoreTools)
	-- get all linters, formatters, & extra tools and merge them into one list
	local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
	local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
	local tools = vim.list_extend(linterList, formatterList)
	vim.list_extend(tools, extraTools)

	-- only unique tools
	table.sort(tools)
	tools = vim.fn.uniq(tools)

	-- remove exceptions not to install
	tools = vim.tbl_filter(function(tool)
		return not vim.tbl_contains(ignoreTools, tool)
	end, tools)
	return tools
end

local function linterConfigs()
	local lint = require("lint")
	local util = require("conform.util")
	lint.linters_by_ft = linters

	linters = {
		flake8 = {
			cmd = util.find_executable({
				".venv/bin/flake8",
			}, "flake8"),
		},
		mypy = {
			cmd = util.find_executable({
				".venv/bin/mypy",
			}, "mypy"),
		},
		ruff = {
			cmd = util.find_executable({
				".venv/bin/ruff",
			}, "ruff"),
		},
	}
end

local function lintTriggers()
	local function doLint()
		vim.defer_fn(function()
			if vim.bo.buftype ~= "" then
				return
			end

			-- condition when to lint https://github.com/mfussenegger/nvim-lint/issues/370#issuecomment-1729671151
			local lintersToUse = require("lint").linters_by_ft[vim.bo.ft]
			local pwd = vim.loop.cwd()
			if not pwd then
				return
			end
			local hasNoFlake8Config = vim.loop.fs_stat(pwd .. "/.flak8") == nil
			if hasNoFlake8Config and vim.bo.ft == "python" then
				lintersToUse = vim.tbl_filter(function(l)
					return l ~= "flake8"
				end, lintersToUse)
			end
			require("lint").try_lint(lintersToUse)
		end, 1)
	end

	vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged", "FocusGained" }, {
		callback = doLint,
	})

	doLint() -- run on initialization
end

-------------------------------------------------------------------------------------------------------------

-- Formatting

return {
	{ --- Linter integration
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		config = function()
			linterConfigs()
			lintTriggers()
		end,
	},
	{ --- Formatter integration
		"stevearc/conform.nvim",
		config = function()
			local utils = require("conform.util")
			require("conform").setup({
				formatters_by_ft = formatters,

				formatters = {
					black = {
						command = utils.find_executable({
							".venv/bin/black",
						}, "black"),
					},
					ruff_format = {
						command = utils.find_executable({
							".venv/bin/ruff",
						}, "ruff"),
					},
					ruff_fix = {
						command = utils.find_executable({
							".venv/bin/ruff",
						}, "ruff"),
					},
				},
			})
		end,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({
						lsp_fallback = vim.tbl_contains(lspFormatting, vim.bo.ft),
						async = true,
						callback = vim.cmd.update,
					})
				end,
				desc = "󰒕 Format & Save",
			},
		},
	},
	{ -- auto-install missing linters & formatters
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>cM", vim.cmd.MasonToolsUpdate, desc = " Mason Update" },
		},
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			local myTools = toolsToAutoinstall(linters, formatters, extraInstalls, dontInstall)
			vim.list_extend(myTools, vim.g.myLsps)

			require("mason-tool-installer").setup({
				ensure_installed = myTools,
				run_on_start = false, -- triggered manually, since not working with lazy-loading
			})

			-- clean unused & install missing
			vim.defer_fn(vim.cmd.MasonToolsInstall, 500)
			vim.defer_fn(vim.cmd.MasonToolsClean, 1000) -- delayed, so noice.nvim is loaded before
		end,
	},
}
