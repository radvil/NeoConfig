return {
  "radvil2/windows.nvim",
  dependencies = "anuvyklack/middleclass",
  event = "VeryLazy",

  keys = {
    {
      "<Leader>wm",
      ":WindowsMaximize<cr>",
      desc = "Window » Maximize/minimize",
    },
    {
      "<Leader>w=",
      ":WindowsEqualize<cr>",
      desc = "Window » Equalize",
    },
    {
      "<Leader>wu",
      ":WindowsToggleAutowidth<cr>",
      desc = "Window » Toggle autowidth",
    },
  },

  config = function()
    require("windows").setup({
      animation = { enable = false },
      autowidth = {
        enable = false,
        winwidth = 5,
        filetype = {
          help = 2,
        },
      },
      ignore = {
        buftype = { "nofile", "quickfix", "edgy" },
        filetype = {
          "noice",
          "flash_prompt",
          "WhichKey",
          "lazy",
          "lspinfo",
          "mason",
          "neo-tree-popup",
          "notify",
          "oil",
          "prompt",
          "TelescopePrompt",
          "TelescopeResults",
          "DressingInput",
          "cmp_menu",
          "noice",
          "neo-tree",
          "Outline",
          "help",
        },
      },
    })
  end,
}
