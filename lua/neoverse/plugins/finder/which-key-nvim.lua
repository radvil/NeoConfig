return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    show_help = false,
    plugins = { spelling = true },
    window = {
      border = "none",
      position = "bottom",
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "🔸",
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
    triggers = { "<leader>", "s" },
    triggers_nowait = {
      "`",
      "'",
      "g`",
      "g'",
      '"',
      "<c-r>",
      "z=",
      "s",
    },
    defaults = {
      mode = { "n", "x" },
      ["g"] = { name = "Goto" },
      ["]"] = { name = "Next" },
      ["["] = { name = "Prev" },
      ["<Leader>/"] = { name = "Telescope" },
      ["<Leader>x"] = { name = "Diagnostics" },
      ["<Leader>b"] = { name = "Buffer" },
      ["<Leader>w"] = { name = "Window" },
      ["<Leader>m"] = { name = "Miscellaneous" },
      ["<Leader>s"] = { name = "Spectre" },
      ["<Leader>S"] = { name = "Session" },
      ["<Leader>f"] = { name = "Float" },
      ["<Leader>g"] = { name = "Git" },
      -- TODO: this doesn't work
      ["<Leader>u"] = { name = "Toggle" },
      ["<Leader>t"] = { name = "Tab" },
      ["<leader>c"] = { name = "Coding" },
    },
  },

  config = function(_, opts)
    local wk = require("which-key")
    local Config = require("neoverse.config")

    if Config.transparent then
      opts.window.border = "single"
      opts.window.padding = { 0, 0, 0, 0 }
    end

    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
