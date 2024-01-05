local M = {}

---@class NeoSnippetOpts
M.opts = {
  delete_check_events = "TextChanged",
  json_snippets = {},
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

M.config = function(_, opts)
  local json_snippets = opts.json_snippets
  if type(json_snippets) == "table" then
    require("luasnip.loaders.from_vscode").lazy_load({ paths = json_snippets })
  end
end

return M
