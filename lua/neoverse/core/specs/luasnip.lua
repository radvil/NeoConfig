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
  local snippet_dirs = nil
  local vscode_loader = require("luasnip.loaders.from_vscode")
  local config = require("neoverse.config")
  vscode_loader.lazy_load()
  if type(config.snippet_dirs) == "function" then
    snippet_dirs = config.snippet_dirs()
  elseif type(config.snippet_dirs) == "table" then
    snippet_dirs = config.snippet_dirs
  else
    snippet_dirs = {}
  end
  vscode_loader.lazy_load({ paths = snippet_dirs })
end

return M
