return {
  -- desc = "Docker language language integration",
  recommended = function()
    return Lonard.extras.wants({
      ft = "dockerfile",
      root = { "Dockerfile", "docker-compose.yml", "compose.yml", "docker-compose.yaml", "compose.yaml" },
    })
  end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_install) == "table" then
        vim.list_extend(opts.ensure_install, { "dockerfile" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "hadolint" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.hadolint,
      })
    end,
  },
}
