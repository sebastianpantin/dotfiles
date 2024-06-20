return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                ruff = { enabled = false },
                autopep8 = { enabled = false },
                flake8 = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
              },
            },
          },
        },
        ruff_lsp = {},
        csharp_ls = {},
        dockerls = {},
        terraformls = {},
        yamlls = {},
        mdx_analyzer = {},
        fsautocomplete = {},
      },
      setup = {
        ruff_lsp = function(_, opts)
          require("lspconfig").ruff_lsp.setup({
            on_attach = function(client, _)
              client.server_capabilities.hoverProvider = false
            end,
            server = opts,
          })
          return true
        end,
      },
    },
  },
}
