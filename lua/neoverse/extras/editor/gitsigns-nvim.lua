---@diagnostic disable: missing-fields
return {
  "lewis6991/gitsigns.nvim",
  event = "LazyFile",
  opts = {
    signcolumn = true,
    numhl = false,
    current_line_blame = false,
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    current_line_blame_opts = {
      virt_text_pos = "right_align",
      virt_text_priority = 100,
      delay = 300,
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local function Kmap(mode, lhs, rhs, desc)
        Lonard.map(mode, lhs, rhs, { buffer = buffer, desc = desc })
      end
      -- stylua: ignore start
      Kmap("n", "<leader>gr", function() gs.refresh() Lonard.info("refreshed", { title = "gitsigns" }) end, "[r]efresh [g]itsigns")
      Kmap("n", "<leader>gub", gs.toggle_current_line_blame, "toggle [g]itsigns line [b]lame")
      Kmap("n", "<leader>guw", gs.toggle_word_diff, "toggle [g]itsigns [w]orddiff")
      Kmap("n", "<leader>gun", gs.toggle_numhl, "toggle [g]itsigns [n]umber")
      Kmap("n", "<leader>guc", gs.toggle_signs, "toggle [g]itsigns [c]olumn")
    end,
  },
}
