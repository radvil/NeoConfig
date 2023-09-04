---@type LazySpec[]
return {
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  { "tpope/vim-repeat", event = "BufReadPre" },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = { default = true },
  },
}
