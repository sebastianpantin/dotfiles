local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
		"onsails/lspkind-nvim",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
	},
}

-- helper function for super tab functionality
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.config = function()
  local cmp = require("cmp")
	local lspkind = require("lspkind")
	local luasnip = require("luasnip")

  vim.opt.completeopt = "menu,menuone,noselect"
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      ["<Right>"] = cmp.mapping.confirm({ select = true }),

      -- super tab functionality
      ["<Tab>"] = cmp.mapping(function(fallback) -- use tab for next suggestion
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback) -- use shift-tab for prev suggestion
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    -- sources for autocompletion
    sources = cmp.config.sources({
      { name = "luasnip" }, -- snippets
      { name = "nvim_lsp" }, -- lsp
      { name = "buffer" }, -- text within current buffer
      { name = "nvim_lua" },
      { name = "path" }, -- file system paths
    }),
    -- configure lspkind for vs-code like icons
    formatting = {
      format = lspkind.cmp_format({
        maxwidth = 50,
        ellipsis_char = "...",
      }),
    },
    window = {
      documentation = false,
      completion = {
        border = "rounded",
        winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      },
    },
    experimental = {
      ghost_text = true,
    },
  })


end

return M
