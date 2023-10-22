return {
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      local formatting = nls.builtins.formatting -- to setup formatters
      local diagnostics = nls.builtins.diagnostics -- to setup linters
      return {
        sources = {
          formatting.prettier.with({
            condition = function(utils)
              return utils.root_has_file(".prettierrc")
            end,
          }),
          formatting.yamlfix,
          formatting.stylua,
          formatting.black.with({ prefer_local = ".venv/bin" }),
          diagnostics.eslint_d.with({
            condition = function(utils)
              return utils.root_has_file(".eslintrc.js")
            end,
          }),
          diagnostics.mypy.with({ prefer_local = ".venv/bin" }),
          diagnostics.flake8.with({
            condition = function(utils)
              return utils.root_has_file(".flake8")
            end,
            prefer_local = ".venv/bin",
          }),
          diagnostics.ruff.with({
            prefer_local = ".venv/bin",
          }),
        },
        debug = true,
      }
    end,
  },
}
