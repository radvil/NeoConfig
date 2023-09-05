local function reset_presets_labels()
  local presets = require("which-key.plugins.presets")

  presets.operators["v"] = nil
  presets.operators["gc"] = "Comments"
  presets.operators["so"] = "Surround » Open/add"
  presets.operators["sd"] = "Surround » Delete"
  presets.operators["s]"] = "Surround » Find next"
  presets.operators["s["] = "Surround » Find prev"
  presets.operators["sc"] = "Surround » Replace/subt"
  presets.operators["sh"] = "Surround » Highlight"

  presets.objects["iW"] = nil
  presets.objects['i"'] = nil
  presets.objects["i'"] = nil
  presets.objects["i("] = nil
  presets.objects["i)"] = nil
  presets.objects["i{"] = nil
  presets.objects["i}"] = nil
  presets.objects["i["] = nil
  presets.objects["i]"] = nil
  presets.objects["i<lt>"] = nil
  presets.objects["i>"] = nil
  presets.objects["i`"] = nil
  presets.objects["aW"] = nil
  presets.objects['a"'] = nil
  presets.objects["a'"] = nil
  presets.objects["a("] = nil
  presets.objects["a)"] = nil
  presets.objects["a{"] = nil
  presets.objects["a}"] = nil
  presets.objects["a["] = nil
  presets.objects["a]"] = nil
  presets.objects["a<lt>"] = nil
  presets.objects["a>"] = nil
  presets.objects["a`"] = nil
  presets.objects["ab"] = [[block [( » ])]]
  presets.objects["aB"] = [[block [{ » ]}]]
  presets.objects["ap"] = [[paragraph]]
  presets.objects["at"] = [[tag]]
  presets.objects["aw"] = [[word]]
  presets.objects["as"] = [[sentence]]

  presets.motions["w"] = "Forward"
  presets.motions["b"] = "Backward"
  presets.motions["T"] = "To prev char of <input>"
  presets.motions["t"] = "To next char of <input>"
  presets.motions["F"] = "Find prev char of <input>"
  presets.motions["f"] = "Find next char of <input>"
  presets.motions["ge"] = "End of prev word"
  presets.motions["e"] = "End of next word"
  presets.motions["%"] = "Match '()' or '{}' or '[]'"
  presets.motions["^"] = "Start of sentence"
  presets.motions["_"] = "Entire line"
  presets.motions["0"] = "Start of line"
  presets.motions["$"] = "End of sentence"
  presets.motions["<M-i>"] = [[variable or value]]
end

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local Utils = require("neoverse.common.utils")
    local Config = require("neoverse.config")

    opts = vim.tbl_deep_extend("force", opts or {}, {
      show_help = false,
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
        filetypes = require("minimal.filetype").Excludes,
      },
      triggers_nowait = {
        "`",
        "'",
        "g`",
        "g'",
        '"',
        "<c-r>",
        "z=",
      },
      defaults = {
        mode = { "n", "v" },
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
        ["<Leader>c"] = { name = "Coding" },
        ["<Leader>u"] = { name = "Toggle" },
        ["<Leader>t"] = { name = "Tab" },
      },
    })

    if Config.transparent then
      opts.window.border = "single"
      opts.window.padding = { 0, 0, 0, 0 }
    end

    if Utils.lazy_has("noice.nvim") then
      opts.defaults["<leader>n"] = { name = "Noice/Notify" }
    end

    if Utils.lazy_has("mini.surround") then
      opts.defaults["s"] = { name = "Surround" }
    end

    return opts
  end,

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
    reset_presets_labels()
  end,
}
