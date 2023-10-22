return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = "mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local null_ls = require("null-ls")
    local null_utils = require("null-ls.utils")
    local pattern = {
      ".null-ls-root",
      ".neoconf.json",
      "Makefile",
      ".git",
    }
    return {
      root_dir = null_utils.root_pattern(unpack(pattern)),
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.shfmt,
      },
    }
  end,
}
