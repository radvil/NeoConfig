---@diagnostic disable: missing-fields

local invoke = function(name)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { string.format("source.%s.ts", name) },
        diagnostics = {},
      },
    })
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "javascript",
          "typescript",
          "tsx",
        })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ---@type NeoLspOpts
    opts = {
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          keys = {
            {
              "<leader>co",
              invoke("organizeImports"),
              desc = "code » organize imports",
            },
            {
              "<leader>cc",
              invoke("removeUnused"),
              desc = "code » remove unused imports",
            },
            {
              "<leader>cm",
              invoke("addMissingImports"),
              desc = "code » add missing imports",
            },
          },
          settings = {
            typescript = {
              format = {
                convertTabsToSpaces = vim.o.expandtab,
                indentSize = vim.o.shiftwidth,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                convertTabsToSpaces = vim.o.expandtab,
                indentSize = vim.o.shiftwidth,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = false,
            },
          },
        },
      },
    },
  },
}
