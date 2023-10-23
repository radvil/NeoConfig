if vim.fn.has("nvim-0.9.0") == 0 then
  vim.api.nvim_echo({
    { "NeoVerse requires Neovim >= 0.9.0\n", "ErrorMsg" },
    { "Press any key to exit", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd([[quit]])
  return {}
end

local get_extras = function()
  -- Some extensions need to be loaded before others
  local prios = {
    ["neoverse.extras.ui.which-key-nvim"] = 10001,
    ["neoverse.extras.ui.legendary-nvim"] = 10000,
    ["neoverse.extras.editor.symbols-outline"] = 100,
  }

  local extras = require("neoverse.config").json.data.extras
  table.sort(extras, function(a, b)
    local pa = prios[a] or 10
    local pb = prios[b] or 10
    if pa == pb then
      return a < b
    end
    return pa < pb
  end)

  ---@param extra string
  return vim.tbl_map(function(extra)
    return { import = extra }
  end, extras)
end

require("neoverse.config").init()

return {
  "folke/lazy.nvim",
  "nvim-lua/plenary.nvim",
  {
    "radvil/NeoVerse",
    priority = 10002,
    config = true,
    version = "*",
    lazy = false,
    cond = true,
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "nvim-tree/nvim-web-devicons",
    opts = { default = true },
    lazy = true,
  },
  get_extras(),
  {
    "folke/persistence.nvim",
    opts = {
      options = {
        "buffers",
        "tabpages",
        "winsize",
        "curdir",
        "help",
      },
    },
    keys = {
      {
        "<Leader>Sr",
        ":NeoSessionRestore<Cr>",
        desc = "Session » Restore",
      },
      {
        "<Leader>Sl",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Session » Restore Last",
      },
      {
        "<Leader>Ss",
        function()
          require("persistence").stop()
        end,
        desc = "Session » Stop Persistence",
      },
    },
    init = function()
      vim.api.nvim_create_user_command("NeoSessionRestore", function()
        require("persistence").load()
        require("neo-tree.command").execute({
          action = "show",
          reveal = true,
        })
      end, { desc = "Session » Restore" })
    end,
  },
}
