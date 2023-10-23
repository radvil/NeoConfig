---@type LazySpec[]
return {
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "nvim-tree/nvim-web-devicons",
    opts = { default = true },
    lazy = true,
  },
}
