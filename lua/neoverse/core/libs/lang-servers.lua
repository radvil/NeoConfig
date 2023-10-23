local JSON = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = "b0o/SchemaStore.nvim",
    ---@type NeoLspOpts
    opts = {
      servers = {
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
}

---@type LazySpec[]
local MARKDOWN = {
  {
    "neovim/nvim-lspconfig",
    ---@type NeoLspOpts
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "markdownlint")
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        vim.list_extend(opts.sources, {
          require("null-ls").builtins.diagnostics.markdownlint,
          require("null-ls").builtins.formatting.markdownlint,
        })
      end
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = "MarkdownPreviewToggle",
    lazy = true,
    ft = { "markdown" },
    -- stylua: ignore
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      {
        "<leader>um",
        ":MarkdownPreviewToggle<cr>",
        desc = "Toggle » Markdown Preview",
      },
    },
  },
}

return { MARKDOWN, JSON }
