local M = {}

M.keys = {
  {
    "<c-space>",
    desc = "Treesitter » Init/increase node selection",
    mode = { "n", "x" },
  },
  {
    "<bs>",
    desc = "Treesitter » Decrease node selection",
    mode = "x",
  },
}

M.opts = {
  highlight = { enable = true },
  indent = { enable = true },
  ensure_installed = {
    "bash",
    "css",
    "diff",
    "html",
    "javascript",
    "json",
    "json5",
    "jsonc",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "<c-space>",
      init_selection = "<c-space>",
      scope_incremental = "<nop>",
      node_decremental = "<bs>",
    },
  },
}

M.config = function(_, opts)
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
end

M.init = function(plugin)
  -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
  -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
  -- no longer trigger the **nvim-treeitter** module to be loaded in time.
  -- Luckily, the only things those plugins need are the custom queries, which we make available
  -- during startup.
  require("lazy.core.loader").add_to_rtp(plugin)
  require("nvim-treesitter.query_predicates")
end

return M
