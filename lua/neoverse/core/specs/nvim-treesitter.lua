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

---@type TSConfig
---@diagnostic disable-next-line: missing-fields
M.opts = {
  highlight = { enable = true },
  indent = { enable = true },
  ensure_installed = {
    "bash",
    "c",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
}

M.config = function(_, opts)
  if type(opts.ensure_installed) == "table" then
    opts.ensure_installed = Lonard.dedup(opts.ensure_installed)
  end
  require("nvim-treesitter.configs").setup(opts)
end

M.init = function(plugin)
  -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
  -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
  -- no longer trigger the **nvim-treesitter** module to be loaded in time.
  -- Luckily, the only things that those plugins need are the custom queries, which we make available
  -- during startup.
  require("lazy.core.loader").add_to_rtp(plugin)
  require("nvim-treesitter.query_predicates")
end

return M
