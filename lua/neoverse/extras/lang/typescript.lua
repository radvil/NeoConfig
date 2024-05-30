---@diagnostic disable: missing-fields

---@type LazySpec[]
return {
  -- desc = "Typescript LSP configuration",
  recommended = function()
    return Lonard.extras.wants({
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root = { "tsconfig.json", "package.json", "jsconfig.json" },
    })
  end,

  {
    "yioneko/nvim-vtsls",
    lazy = true,
    opts = {},
    config = function(_, opts)
      require("vtsls").config(opts)
    end,
  },

  {
    "nvim-treesitter",
    optional = true,
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
    "nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gs",
              function()
                require("vtsls").commands.goto_source_definition(0)
              end,
              desc = "Goto Source Definition",
            },
            {
              "gr",
              function()
                require("vtsls").commands.file_references(0)
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              function()
                require("vtsls").commands.organize_imports(0)
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cm",
              function()
                require("vtsls").commands.add_missing_imports(0)
              end,
              desc = "Add missing imports",
            },
            {
              "<leader>cc",
              function()
                require("vtsls").commands.remove_unused_imports(0)
              end,
              desc = "Remove unused imports",
            },
            {
              "<leader>cH",
              function()
                require("vtsls").commands.fix_all(0)
              end,
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                require("vtsls").commands.select_ts_version(0)
              end,
              desc = "Select TS workspace version",
            },
          },
        },
      },
      standalone_setups = {
        vtsls = function(_, opts)
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
          local plugins = vim.tbl_get(opts.settings, "vtsls", "tsserver", "globalPlugins")
          -- allow plugins to have a key for proper merging
          -- remove the key here
          if plugins then
            opts.settings.vtsls.tsserver.globalPlugins = vim.tbl_values(plugins)
          end
        end,
      },
    },
  },
}
