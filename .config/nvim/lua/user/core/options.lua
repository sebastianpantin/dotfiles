local opt = vim.opt -- For conciseness
local g = vim.g
-- Shell
opt.shell = "/bin/bash"

-- Mouse
opt.mouse = "a"

-- File settings
opt.backup = false
opt.swapfile = false
opt.fileencoding = "utf-8"
opt.undofile = true
opt.writebackup = false

-- set numbered lines
opt.number = true
opt.relativenumber = false
opt.laststatus = 3
opt.ruler = false
opt.showcmd = false

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Cursor line
opt.cursorline = true

-- Seach settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.showmode = false
opt.guifont = "monospace:h17"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Fill chars
opt.fillchars = opt.fillchars + "eob: "
opt.fillchars:append({
	stl = " ",
})

-- Shortmess
opt.shortmess:append("c")

-- Timeout
opt.timeoutlen = 400

-- CMDs
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])

vim.filetype.add({
	extension = {
		conf = "dosini",
	},
})

-- disable some builtin vim plugins
local default_plugins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in pairs(default_plugins) do
	vim.g["loaded_" .. plugin] = 1
end
