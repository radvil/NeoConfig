local M = {}

M.keys = {
  {
    "<Leader>wm",
    ":WindowsMaximize<cr>",
    desc = "window » maximize/minimize",
  },
  {
    "<Leader>w=",
    ":WindowsEqualize<cr>",
    desc = "window » equalize",
  },
  {
    "<Leader>wu",
    ":WindowsToggleAutowidth<cr>",
    desc = "window » toggle autowidth",
  },
}

M.opts = {
  animation = { enable = true },
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
      "TelescopeResults",
      "TelescopePrompt",
      "neo-tree-popup",
      "DressingInput",
      "flash_prompt",
      "cmp_menu",
      "neo-tree",
      "WhichKey",
      "Outline",
      "prompt",
      "lspinfo",
      "notify",
      "mason",
      "noice",
      "noice",
      "lazy",
      "help",
      "oil",
    },
  },
}

M.config = function(_, opts)
  vim.o.winwidth = 10
  vim.o.winminwidth = 10
  vim.o.equalalways = false
  require("windows").setup(opts)
end

return M
