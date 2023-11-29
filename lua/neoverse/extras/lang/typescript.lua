---@diagnostic disable: missing-fields
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
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Code » Organize Imports",
            },
            {
              "<leader>cc",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Code » Remove Unused Imports",
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
