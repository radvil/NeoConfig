return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    show_help = true,
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    window = {
      border = vim.g.neo_winborder,
      padding = vim.g.neo_transparent and { 0, 0, 0, 0 } or { 1, 2, 1, 2 },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = vim.g.neovide and "+ " or "🔸",
    },
    disable = {
      buftypes = { "terminal" },
      filetypes = {
        "DiffviewFiles",
        "NeogitStatus",
        "Dashboard",
        "dashboard",
        "MundoDiff",
        "NvimTree",
        "neo-tree",
        "Outline",
        "prompt",
        "Mundo",
        "alpha",
        "help",
        "dbui",
        "edgy",
        "dirbuf",
        "fugitive",
        "fugitiveblame",
        "gitcommit",
        "Trouble",
        "alpha",
        "help",
        "qf",
      },
    },
    triggers_blacklist = {
      n = {
        "[",
        "]",
        "z",
        "`",
      },
    },
    layout = {
      align = "left",
      spacing = 5,
      height = {
        min = 3,
        max = 9,
      },
    },
    defaults = {
      mode = { "n", "x" },
      ["g"] = { name = "goto" },
      ["z"] = { name = "fold" },
      ["]"] = { name = "next" },
      ["["] = { name = "previous" },
      ["<Leader>/"] = { name = "[/]elescope" },
      ["<Leader>x"] = { name = "diagnosti[x]" },
      ["<Leader>b"] = { name = "[b]uffer" },
      ["<leader>c"] = { name = "[c]ode" },
      ["<Leader>w"] = { name = "[w]indow" },
      ["<Leader>m"] = { name = "[m]iscellaneous" },
      ["<Leader>s"] = { name = "[s]pectre" },
      ["<Leader>S"] = { name = "[S]ession" },
      ["<Leader>f"] = { name = "[f]iles" },
      ["<Leader>g"] = { name = "[g]it" },
      ["<Leader>u"] = { name = "[u]ndo/toggle" },
      ["<Leader>t"] = { name = "[t]erminal" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
