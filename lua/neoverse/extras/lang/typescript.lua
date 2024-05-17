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

local inlay_hints_settings = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

---@type LazySpec[]
return {
  {
    "nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_install) == "table" then
        vim.list_extend(opts.ensure_install, {
          "javascript",
          "typescript",
          "tsx",
        })
      end
    end,
  },
  {
    "nvim-lspconfig",
    ---@type NeoLspOpts
    dependencies = {
      "dmmulroy/ts-error-translator.nvim",
      ft = {
        "typescriptreact",
        "typescript",
        "tsx",
      },
    },
    opts = {
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          -- mason = false,
          -- cmd = {
          --   os.getenv("HOME") .. "/.bun/bin/typescript-language-server",
          --   "--stdio",
          -- },
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
            javascript = {
              inlayHints = inlay_hints_settings,
            },
            typescript = {
              inlayHints = inlay_hints_settings,
            },
          },
        },
      },
    },
  },
}
