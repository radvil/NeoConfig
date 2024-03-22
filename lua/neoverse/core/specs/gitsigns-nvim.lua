---@diagnostic disable: missing-fields
local M = {}

M.opts = {
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
    local function Kmap(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = string.format("gitsigns %s", desc) })
    end

    -- stylua: ignore start
    Kmap("n", "<leader>gr", function() gs.refresh() Lonard.info("refreshed", { title = "gitsigns" }) end, "refresh view")
    Kmap("n", "<leader>gun", gs.toggle_numhl, "toggle number")
    Kmap("n", "<leader>guu", gs.toggle_signs, "toggle signcolumn")
    Kmap("n", "<leader>gud", gs.toggle_word_diff, "toggle word diff")
    Kmap("n", "<leader>gub", gs.toggle_current_line_blame, "toggle current line blame")
  end,
}

return M
