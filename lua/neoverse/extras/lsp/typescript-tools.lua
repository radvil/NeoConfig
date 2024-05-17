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
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "tsx" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
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
    config = function(_, opts)
      require("typescript-tools").setup(opts)
      local Kmap = function(lhs, cmd, desc)
        cmd = string.format("<cmd>TSTools%s<cr>", cmd)
        desc = string.format("typescript » %s", desc)
        return Lonard.map("n", lhs, cmd, { desc = desc })
      end
      Kmap("gs", "GoToSourceDefinition", "goto source definition")
      Kmap("<leader>cm", "AddMissingImports", "add missing imports")
      Kmap("<leader>co", "OrganizeImports", "organize imports")
      Kmap("<leader>cc", "RemoveUnusedImports", "clear imports")
      Kmap("<leader>cR", "RenameFile", "rename file")
    end,
  },
}
