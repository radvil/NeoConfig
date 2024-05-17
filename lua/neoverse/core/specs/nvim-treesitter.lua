---@type LazySpec
local M = {}

M.opts = {
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
}

---@param opts TSConfig
M.config = function(_, opts)
  ---@return string[]
  local function norm(ensure)
    return ensure == nil and {} or type(ensure) == "string" and { ensure } or ensure
  end
  opts.ensure_install = Lonard.dedup(norm(opts.ensure_install))
  require("nvim-treesitter").setup(opts)

  -- backwards compatibility with the old treesitter config for indent
  if vim.tbl_get(opts, "indent", "enable") then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end

  -- backwards compatibility with the old treesitter config for highlight
  if vim.tbl_get(opts, "highlight", "enable") then
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end
end

return M
