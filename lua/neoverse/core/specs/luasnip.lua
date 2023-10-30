local M = {}

M.opts = {
  delete_check_events = "TextChanged",
  history = true,
}

M.keys = {
  {
    "<Tab>",
    function()
      return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    end,
    expr = true,
    mode = "i",
  },
  {
    "<Tab>",
    function()
      require("luasnip").jump(1)
    end,
    mode = "s",
  },
  {
    "<S-Tab>",
    function()
      require("luasnip").jump(-1)
    end,
    mode = { "i", "s" },
  },
}

M.config = function()
  local vscode_loader = require("luasnip.loaders.from_vscode")
  vscode_loader.lazy_load()
  local user_snippets = {}
  local dir_opts = vim.g.neo_snippet_dirs
  if type(dir_opts) == "string" then
    vim.list_extend(user_snippets, { dir_opts })
  else
    vim.list_extend(user_snippets, dir_opts or {})
  end
  vscode_loader.lazy_load({ paths = user_snippets })
end

return M
