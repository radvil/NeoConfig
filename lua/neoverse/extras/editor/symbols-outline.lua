return {
  "simrat39/symbols-outline.nvim",
  cmd = "SymbolsOutline",
  keys = {
    {
      "<Leader>fs",
      "<cmd>SymbolsOutline<cr>",
      desc = "Finder » Symbols Outline",
    },
  },
  opts = function()
    local Config = require("neoverse.config")
    local opts = {
      width = 40,
      wrap = false,
      position = "right",
      auto_close = false,
      show_guides = true,
      auto_preview = false,
      show_numbers = false,
      autofold_depth = nil,
      relative_width = false,
      auto_unfold_hover = false,
      show_symbol_details = false,
      show_relative_numbers = false,
      highlight_hovered_item = true,
      fold_markers = { "", "" },
      keymaps = {
        close = { "q" },
        goto_location = { "<cr>" },
        focus_location = "o",
        rename_symbol = "gr",
        code_actions = "ga",
        fold = "zc",
        unfold = "zo",
        fold_all = "zC",
        unfold_all = "zO",
        fold_reset = "R",
        hover_symbol = nil,
        toggle_preview = nil,
      },
      symbols = {},
      symbol_blacklist = {},
    }

    local AllowedSymbolNames = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    }

    for kind, symbol in pairs(require("symbols-outline.config").defaults.symbols) do
      opts.symbols[kind] = {
        icon = Config.icons.Kinds[kind] or symbol.icon,
        hl = symbol.hl,
      }
      if not vim.tbl_contains(AllowedSymbolNames, kind) then
        table.insert(opts.symbol_blacklist, kind)
      end
    end
    return opts
  end,
}
