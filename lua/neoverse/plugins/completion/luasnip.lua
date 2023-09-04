return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  opts = {
    delete_check_events = "TextChanged",
    history = true,
  },
  keys = {
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
  },
  config = function()
    local vscode_loader = require("luasnip.loaders.from_vscode")
    vscode_loader.lazy_load()
    vscode_loader.lazy_load({
      paths = require("neoverse.config").snippet_dirs,
    })
  end,
}
