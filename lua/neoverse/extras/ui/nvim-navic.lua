return {
  "SmiteshP/nvim-navic",
  lazy = true,
  init = function()
    vim.g.navic_silence = true
    require("neoverse.utils").lsp.on_attach(function(client, buffer)
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, buffer)
      end
    end)
  end,
  opts = function()
    return {
      icons = require("neoverse.config").icons.Kinds,
      lazy_update_context = true,
      -- separator = " » ",
      separator = "  ",
      highlight = true,
      depth_limit = 7,
    }
  end,
}
