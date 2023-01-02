vim.g.python3_host_prog = vim.env.PYENV_ROOT .. '/shims/python3'
require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.functions")
require("config.autocommands")
