return {
  "nvim-treesitter/nvim-treesitter",
  event = { "LazyFile", "VeryLazy" },
  build = ":TSUpdate",

  keys = {
    {
      "<c-space>",
      desc = "Treesitter » Init/increase selection",
      mode = { "n", "x" },
    },
    {
      "<bs>",
      desc = "Treesitter » Decrease selection",
      mode = "x",
    },
  },

  opts = {
    ensure_installed = {
      "bash",
      "css",
      "diff",
      "html",
      "javascript",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "vim",
      "yaml",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "markdown" },
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "<c-space>",
        init_selection = "<c-space>",
        scope_incremental = "<nop>",
        node_decremental = "<bs>",
      },
    },
  },

  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)
  end,
}
