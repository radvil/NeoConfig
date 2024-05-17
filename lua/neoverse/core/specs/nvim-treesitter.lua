---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  version = nil,
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  dev = false,
  cmd = {},
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_install = {
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
  },
  ---@param opts TSConfig
  config = function(_, opts)
    ---@return string[]
    local function norm(ensure)
      return ensure == nil and {} or type(ensure) == "string" and { ensure } or ensure
    end
    opts.ensure_install = Lonard.dedup(norm(opts.ensure_install))
    require("nvim-treesitter").setup(opts)
  end,
}
