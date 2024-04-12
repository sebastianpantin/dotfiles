return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
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
          diagnostics.mypy.with({ prefer_local = ".venv/bin" }),
        },
        debug = true,
      }
    end,
  },
}
