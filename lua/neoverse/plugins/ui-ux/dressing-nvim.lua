return {
  "stevearc/dressing.nvim",
  lazy = true,
  opts = {
    input = {
      border = "single",
      win_options = { winblend = 10 },
      mappings = {
        i = { ["<a-space>"] = "Close" },
      },
    },
  },
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
  config = function(_, opts)
    if require("neoverse.config").transparent then
      opts.input.win_options.winblend = 0
    end
    require("dressing").setup(opts)
  end,
}
