return {
  desc = "Use native snippets instead of LuaSnip. Only works on Neovim >= 0.10!",
  recommended = true,
  {
    "L3MON4D3/LuaSnip",
    enabled = false,
  },
  {
    "nvim-cmp",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      {
        "garymjr/nvim-snippets",
        opts = { friendly_snippets = true },
      },
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "snippets" })
      opts.snippet = {
        expand = function(args)
          return Lonard.cmp.expand(args.body)
        end,
      }
    end,
    keys = {
      {
        "<Tab>",
        function()
          return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
}
