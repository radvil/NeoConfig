return {
  "RRethy/vim-illuminate",
  event = "LazyFile",

  keys = {
    {
      "<A-p>",
      function()
        require("illuminate").goto_prev_reference(false)
      end,
      desc = "Vim Illuminate » Prev ref",
      mode = { "n", "x", "o" },
    },
    {
      "<A-n>",
      function()
        require("illuminate").goto_next_reference(false)
      end,
      desc = "Vim Illuminate » Next ref",
      mode = { "n", "x", "o" },
    },
  },

  opts = {
    delay = 200,
    filetypes_denylist = {
      "fugitiveblame",
      "DiffviewFiles",
      "NeogitStatus",
      "Dashboard",
      "dashboard",
      "MundoDiff",
      "gitcommit",
      "NvimTree",
      "fugitive",
      "neo-tree",
      "Outline",
      "Trouble",
      "prompt",
      "dirbuf",
      "alpha",
      "Mundo",
      "dbui",
      "help",
      "edgy",
      "qf",
    },
  },

  config = function(_, opts)
    require("illuminate").configure(opts)
  end,

  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        if require("neoverse.utils").buf_has_keymaps({ "<A-n>", "<A-p>" }) then
          pcall(vim.keymap.del, "n", "<A-n>", { buffer = true })
          pcall(vim.keymap.del, "n", "<A-p>", { buffer = true })
        end
      end,
    })
  end,
}
