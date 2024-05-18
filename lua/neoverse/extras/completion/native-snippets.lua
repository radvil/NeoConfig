return {
  desc = "Use native snippets instead of LuaSnip. Only works on Neovim >= 0.10!",
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
        opts = {
          friendly_snippets = true,
          search_paths = {
            os.getenv("DOTFILES") .. "/nvim/assets/snippets/all",
            os.getenv("DOTFILES") .. "/nvim/assets/snippets/angular",
          },
        },
      },
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "snippets" })
      opts.snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      }
    end,
    keys = {
      {
        "<Tab>",
        function()
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
            return
          end
          return "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<Tab>",
        function()
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        end,
        silent = true,
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          if vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
            return
          end
          return "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
}
