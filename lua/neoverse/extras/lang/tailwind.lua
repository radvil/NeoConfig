return {
  -- desc = "Tailwindcss LSP integration",
  recommended = function()
    return Lonard.extras.wants({
      root = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
      },
    })
  end,

  {
    "neovim/nvim-lspconfig",
    ---@type NeoLspOpts
    opts = {
      servers = {
        tailwindcss = {
          -- mason = false,
          -- cmd = {
          --   os.getenv("HOME") .. "/.bun/bin/tailwindcss-language-server",
          --   "--stdio",
          -- },
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
      },
      standalone_setups = {
        tailwindcss = function(_, opts)
          local tw = require("lspconfig.server_configurations.tailwindcss")
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = true,
      },
    },
    opts = function(_, opts)
      if opts and opts.formatting then
        -- original NeoVerse kind icon formatter
        local format_kinds = opts.formatting.format
        opts.formatting.format = function(entry, item)
          format_kinds(entry, item) -- add icons
          return require("tailwindcss-colorizer-cmp").formatter(entry, item)
        end
      end
    end,
  },
}
