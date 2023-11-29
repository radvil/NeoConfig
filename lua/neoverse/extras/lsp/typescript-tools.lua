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
    "pmizio/typescript-tools.nvim",
    event = "LazyFile",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    keys = {
      {
        "<leader>cm",
        "<cmd>TSToolsAddMissingImports<cr>",
        desc = "typescript » add missing imports",
      },
      {
        "<leader>co",
        "<cmd>TSToolsOrganizeImports<cr>",
        desc = "typescript » add organize imports",
      },
      {
        "<leader>cc",
        "<cmd>TSToolsRemoveUnusedImports<cr>",
        desc = "typescript » add clear imports",
      },
      {
        "<leader>cR",
        "<cmd>TSToolsRenameFile<cr>",
        desc = "typescript » rename file",
      },
      {
        "gs",
        "<cmd>TSToolsGoToSourceDefinition<cr>",
        desc = "typescript » add clear imports",
      },
    },
    opts = {
      settings = {
        tsserver_locale = "en",
        complete_function_calls = false,
        separate_diagnostic_server = false,
        expose_as_code_action = "all",
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeCompletionsForModuleExports = true,
          quotePreference = "auto",
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
          convertTabsToSpaces = vim.o.expandtab,
          indentSize = vim.o.shiftwidth,
          tabSize = vim.o.tabstop,
        },
        tsserver_plugins = {},
      },
    },
  },
}
