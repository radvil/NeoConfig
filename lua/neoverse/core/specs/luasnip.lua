local M = {}

M.keys = {
  {
    "<Tab>",
    function()
      return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    end,
    expr = true,
    mode = "i",
  },
  {
    "<Tab>",
    function()
      require("luasnip").jump(1)
    end,
    mode = "s",
  },
  {
    "<S-Tab>",
    function()
      require("luasnip").jump(-1)
    end,
    mode = { "i", "s" },
  },
}

M.dependencies = {
  "rafamadriz/friendly-snippets",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
  {
    "nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      if type(opts) == "table" then
        opts.snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        }
        table.insert(opts.sources, { name = "luasnip" })
      end
    end,
  },
}

---@class NeoSnippetOpts
M.opts = {
  delete_check_events = "TextChanged",
  json_snippets = {},
  history = true,
}

M.config = function(_, opts)
  local json_snippets = opts.json_snippets
  if type(json_snippets) == "table" then
    require("luasnip.loaders.from_vscode").lazy_load({ paths = json_snippets })
  end
end

return M
