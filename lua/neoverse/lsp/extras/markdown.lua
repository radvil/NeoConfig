---@type LazySpec[]
local M = {
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

return M
